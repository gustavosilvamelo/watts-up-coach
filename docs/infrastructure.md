# Infrastructure

Environment map, service decisions, tooling strategy, and learning goals for the technical layer of the project. This document records what is confirmed available, what the options are for each open problem, and which technologies will be learned in the process of implementing them.

---

## 1. Databricks Free Edition — confirmed capabilities

Probed on 2026-09-16 via Databricks CLI v1.17.0 (profile `gustavo-lab`, workspace `dbc-72b61f75-d522`, AWS us-east-2).

| Resource | Status | Detail |
|---|---|---|
| Unity Catalog | ✅ operational | `workspace` catalog (MANAGED). Schema create/delete confirmed via REST API. |
| Foundation model serving | ✅ operational | 11 endpoints ready: 8 chat LLMs (Llama 3.1 8B / 3.3 70B / 4 Maverick, GPT-OSS 120B / 20B, Qwen3 Next, Qwen3.5 122B, Gemma 3 12B) + 3 embedding models (BGE Large En 1024d, GTE Large En, Qwen3 Embedding 0.6B). Inference confirmed via REST API. |
| Embeddings | ✅ operational | BGE Large En tested: 1024 dimensions, ~10ms latency. No provisioning required. |
| SQL Warehouse | ✅ exists | "Serverless Starter Warehouse" (2X-Small). Auto-starts on first query, auto-stops after idle period. On-demand by design. |
| Vector Search API | ✅ API exists | `vector-search-endpoints` CLI group present. Zero endpoints created. Serverless endpoint availability in Free Edition not yet confirmed. |
| Jobs / Pipelines | ✅ APIs exist | Zero jobs or DLT pipelines created. Serverless job compute available (no classic clusters). |
| Secret Scopes | API exists | Zero scopes created. Required before storing any API keys. |
| Classic clusters | ❌ not available | Consistent with Free Edition being 100% serverless. |

**Key operational note.** The Databricks CLI (`databricks serving-endpoints query`) has a parsing bug in PowerShell when endpoint names contain multiple hyphens. Use the REST API directly or the Python SDK (`databricks-sdk`) for scripted inference — the CLI is for interactive exploration, not automation.

---

## 2. Vector Search — on-demand options

Context: this is not a public-facing service. There is no requirement for a persistent endpoint that stays alive and serves requests with sub-second cold-start. The use pattern is: user asks a question → system retrieves relevant chunks → LLM generates answer → session ends.

### Option A — SQL Warehouse + `vector_cosine_similarity` (recommended for initial corpus)

Store precomputed embeddings in a Delta table. Query similarity via the Serverless SQL Warehouse.

```sql
SELECT chunk_id, text, source, evidence_tier,
       vector_cosine_similarity(embedding, :query_embedding) AS score
FROM workspace.watts_up.literature_chunks
ORDER BY score DESC
LIMIT 10
```

| Property | Value |
|---|---|
| Cold start | ~5–15s (warehouse auto-starts) |
| Search type | Exact cosine scan — no ANN index |
| Corpus limit before slowdown | ~50k chunks (milliseconds per query below that) |
| Cost | Zero beyond what the warehouse already exists to do |
| Implementation complexity | Low — one Delta table, one query |
| Status | Available now, no provisioning needed |

**Fits the initial corpus.** Estimated size at launch: 5k–20k chunks from curated papers. Well within the limit.

### Option B — FAISS in a serverless job (on-demand ANN index)

Build a FAISS index (Meta's ANN library, used under the hood by most vector databases) as part of the ingestion pipeline. Save the index file to S3 or DBFS. Load and query it in a serverless job triggered on demand.

```
Ingestion job (serverless)
  → generate embeddings via BGE Large En
  → build FAISS index (IVF or HNSW)
  → serialize index to s3://watts-up-coach-docs/faiss/index.bin

Query job (serverless, on-demand)
  → deserialize index from S3 (~10–30s cold start)
  → run ANN query in memory
  → return top-K chunks
  → job terminates
```

| Property | Value |
|---|---|
| Cold start | 10–30s (job spin-up + index load from S3) |
| Search type | Approximate nearest neighbors — scales to millions of vectors |
| Cost | Serverless job compute only (fractions of a DBU per query) |
| Implementation complexity | Medium — requires FAISS dependency, index lifecycle management |
| Status | Available, requires implementation |

### Option C — Databricks Vector Search Serverless endpoint

Databricks offers a `SERVERLESS` endpoint type that scales to zero when idle, unlike the `STANDARD` (always-on, continuous cost) type. Availability in Free Edition is **not yet confirmed** — requires a create-endpoint test.

| Property | Value |
|---|---|
| Cold start | ~30–60s on first query after idle (managed by Databricks) |
| Search type | Managed ANN with Delta Sync (index updates automatically when source table changes) |
| Cost | Serverless billing — only when active; zero when idle |
| Implementation complexity | Low once endpoint is confirmed available |
| Status | Pending availability test |

### Decision path

```
Start with Option A (SQL Warehouse + cosine scan)
  → if corpus grows past ~50k chunks        → migrate to Option B or C
  → if Option C confirmed available free    → prefer C over B (managed, Delta Sync)
  → if latency becomes unacceptable for UX  → re-evaluate
```

---

## 3. Storage — Amazon S3

### Why S3 alongside Databricks

The Databricks Free Edition workspace has internal managed storage (DBFS), but it is opaque — there is no direct access to the underlying S3 bucket. An explicit S3 bucket owned by the project serves two purposes the Databricks managed storage does not:

1. **Document intake.** Raw PDFs and paper files are dropped into S3. An ingestion job reads from there, extracts text, generates embeddings, and writes chunks to a Delta table. This decouples "where source material lives" from "where processed data lives" — a standard data pipeline pattern.
2. **FAISS index persistence.** If Option B is used, the serialized index lives in S3, readable by any serverless job without re-building from scratch on every query.

### Free tier

AWS S3 Free Tier: **5 GB storage + 20k GET + 2k PUT requests per month**, permanent (not time-limited). Sufficient for document intake at this scale.

### Databricks–S3 connection — learning goal

Connecting Databricks serverless compute to S3 requires three pieces working together:

1. **IAM role (AWS side)** — a role with `s3:GetObject`, `s3:PutObject`, `s3:ListBucket` on the target bucket.
2. **Instance profile (Databricks side)** — a Databricks resource that "wraps" the IAM role and makes it available to notebooks and jobs.
3. **External location (Unity Catalog)** — a UC object that maps a `s3://` path to a credential, making the path addressable as `s3a://` from Spark.

This connection setup is a **guided learning step** in the execution plan — the goal is to understand each layer (IAM trust policy, cross-account role assumption, Unity Catalog credential model) while building it, not just copy-paste a configuration.

**The setup goes in Terraform** (see §4), not in the bundle or manually, so that it is reproducible and auditable.

---

## 4. Infrastructure as Code — Terraform

### Why Terraform for this project

The project has two distinct kinds of configuration:

| Kind | Tool | Examples |
|---|---|---|
| **Infrastructure primitives** — exist outside application lifecycle, rarely change, affect multiple services at once | **Terraform** | IAM roles, S3 bucket + policies, Databricks instance profile, Unity Catalog external location, secret scope |
| **Application resources** — deploy with the code, change per environment, owned by the bundle | **Databricks Asset Bundle** | Jobs, notebooks, DLT pipelines, model serving configs, Vector Search indexes |

If the S3–Databricks connection were set up manually or via CLI, it would be invisible to version control and impossible to reproduce in a second workspace. Terraform makes the connection an auditable, versioned artifact.

Learning Terraform here covers patterns that transfer directly to production engineering: provider configuration, state management, resource dependencies, `terraform plan` as a safety gate, and secrets handling.

### What Terraform manages in this project

```
terraform/
  main.tf           # provider config (aws + databricks)
  variables.tf      # workspace URL, account IDs, bucket name
  outputs.tf        # instance profile ARN, external location name

  modules/
    s3_intake/      # S3 bucket + bucket policy
    iam_role/       # IAM role + trust policy for Databricks
    databricks_s3/  # instance profile + Unity Catalog credential + external location
    secret_scope/   # Databricks secret scope for API keys
```

### What stays in the bundle (not Terraform)

Jobs, notebooks, DLT pipelines, model serving endpoint configs, Vector Search index definitions. These change with every feature branch and are deployed via `databricks bundle deploy`.

### Learning path

Each Terraform module is a **guided step** — the execution plan walks through:

1. Terraform CLI setup and provider authentication (AWS credentials + Databricks OAuth).
2. Creating the S3 bucket and understanding bucket policies.
3. Creating the IAM role and understanding trust policies (who can assume this role).
4. Registering the instance profile in Databricks and understanding how serverless compute uses it.
5. Creating the Unity Catalog external location and testing `LIST` access from a notebook.
6. Creating the secret scope and understanding the difference between Databricks-backed and Azure Key Vault–backed scopes.

Each step is done in a separate `terraform apply` with a `plan` review first — the goal is to read and understand what Terraform is about to do before confirming.

---

## 5. Services map

```
AWS (free tier, permanent)
  S3 bucket: watts-up-coach-docs
    ├── papers/          raw PDFs for ingestion
    ├── faiss/           serialized FAISS index (Option B)
    └── exports/         one-off data exports

Databricks Free Edition (workspace dbc-72b61f75-d522)
  Unity Catalog (workspace catalog)
    └── watts_up schema (to create)
        ├── literature_chunks    Delta table: chunks + embeddings
        ├── athletes             Delta table: athlete profiles
        ├── activities           Delta table: raw activities
        └── curated              Delta table: CTL/ATL/TSB + derived metrics
  Model Serving (system endpoints, no provisioning)
    ├── databricks-bge-large-en          embedding model
    └── databricks-meta-llama-3-3-70b    LLM for dev/testing
  SQL Warehouse (auto-start / auto-stop)
    └── Serverless Starter Warehouse     query engine for Delta tables
  Jobs (to create via bundle)
    ├── ingest_papers            S3 → embeddings → literature_chunks
    └── ingest_activities        Intervals.icu → activities → curated

Terraform (manages the bridge between AWS and Databricks)
  IAM role + instance profile
  Unity Catalog external location → s3://watts-up-coach-docs
  Secret scope (API keys: Intervals.icu, Claude)
```

---

## 6. Open items

| Item | What needs to happen | Priority |
|---|---|---|
| Vector Search Serverless availability | Create a test endpoint and observe Free Edition response (blocked / accepted / cost shown) | Medium — needed before committing to Option A permanently |
| S3 bucket creation | Create bucket via Terraform (step 1 of Terraform learning path) | High — needed before first ingestion |
| IAM + instance profile | Terraform module for Databricks–S3 bridge | High — blocks ingestion job |
| Secret scope | Create via Terraform, store Intervals.icu and Claude API keys | High — blocks any job that calls external APIs |
| Terraform CLI setup | Install, configure AWS + Databricks providers, initialize state | First step — blocks all other Terraform work |
