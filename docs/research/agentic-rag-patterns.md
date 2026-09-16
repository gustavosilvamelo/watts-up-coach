# Agentic RAG Patterns — Research Reference

Research notes on Agentic RAG design (Claude as orchestrator + MCP + Databricks Vector Search) for a cycling coaching agent, with feedback loop and versioning. Focus on best practices, risks, and known patterns for health/coaching domains where the output shapes user behavior.

Captured: 2026-09-16.

## Methodology note

WebSearch was blocked by the harness despite user authorization; only WebFetch on known URLs worked. Coverage therefore comes from arXiv papers, official blogs (Anthropic, Databricks, LangChain, Microsoft Research, Google Research), Langfuse/MLflow docs, and Simon Willison. Nothing was invented; where no primary source was found, the note says "no direct evidence".

---

## 1. Mature Agentic RAG patterns

- **Orchestrator-workers and evaluator-optimizer are the reference patterns** today. Anthropic ("Building Effective Agents", Schluntz & Zhang, 2024) distinguishes *workflows* (flows with predefined code) from *agents* (LLM decides the loop) and recommends starting simple: prompt chaining → routing → parallelization → orchestrator-workers → evaluator-optimizer → autonomous agent. Multi-agent only when the gain justifies cost/latency. https://www.anthropic.com/engineering/building-effective-agents
- **Anthropic's multi-agent research system (2025)** operates as lead-agent + parallel sub-agents + dedicated CitationAgent (post-processing for attribution). Reported gain of up to 90% in time with parallel sub-agents, but costs many more tokens. https://www.anthropic.com/engineering/built-multi-agent-research-system
- **Advanced RAG (Gao et al., "Retrieval-Augmented Generation for LLMs: A Survey", arXiv:2312.10997, 2024)** splits into Naive / Advanced / Modular. Modular = query rewriting + router + multiple retrievers + reranker + fusion. https://arxiv.org/abs/2312.10997
- **Self-RAG (Asai et al., arXiv:2310.11511)** introduces "reflection tokens" for on-demand retrieval and output critique; improves factuality and citation. https://arxiv.org/abs/2310.11511
- **Corrective RAG - CRAG (Yan et al., arXiv:2401.15884)** runs a lightweight evaluator to judge retrieval quality and triggers a fallback (web search) on low confidence. "Decompose-then-recompose" pattern. https://arxiv.org/abs/2401.15884
- **GraphRAG (Edge et al., Microsoft Research, arXiv:2404.16130, 2024)** for "global" questions over a corpus (themes, cohort comparisons). https://arxiv.org/abs/2404.16130
- **Agentic RAG Survey (Singh et al., arXiv:2501.09136, 2025)** organizes by agent cardinality, control, autonomy. Notes that evaluation is still an open area. https://arxiv.org/abs/2501.09136

Reasonable topology for this case: **router LLM → N specialist retrievers (athlete / cohort / literature) → reranker → generator with self-check + CitationAgent**. Do not jump straight to autonomous multi-agent.

## 2. Robust grounding and citation

- **Dedicated CitationAgent** (Anthropic multi-agent) and Self-RAG's citation tokens are the strongest evidence that attributing *after* generation, with the text already produced, reduces fabrication vs. asking for citation in the prompt.
- **Structured output with mandatory schema** (Anthropic tool-use, Claude): force `claim`, `source_id`, `source_span` fields in the output; do not accept a response without them. This is the practical implementation of the pattern.
- **Faithfulness/groundedness as a dedicated judge**: Databricks Mosaic AI Agent Evaluation treats "groundedness" as a separate axis. https://www.databricks.com/blog/announcing-mosaic-ai-agent-framework-and-agent-evaluation
- **ARES (Saad-Falcon et al., arXiv:2311.09476)** framework to judge context relevance / answer faithfulness / answer relevance. https://arxiv.org/abs/2311.09476
- **Known risks**: (a) *citation fabrication* — the model cites plausible but nonexistent IDs; mitigate by validating IDs against Vector Search before rendering; (b) *selective grounding* — the model picks only the snippet that confirms the thesis; mitigate by retrieving top-k > used and forcing the judge to score coverage.

## 3. Safety in health/coaching

Training prescription is not medical prescription, but it falls into a gray zone recognized in the literature.

- **Google PH-LLM (Cosentino et al., arXiv:2406.06474)** — the paper itself states that "further development and evaluation are necessary in the safety-critical personal health domain". Results: 88% on fitness MCQ, but the authors explicitly do not consider it production-ready. https://arxiv.org/abs/2406.06474
- **Google AMIE (Tu et al., 2024)** for medical dialogue uses multi-axis evaluation (history-taking, safety, empathy, communication) and blinded crossover with actors; a replicable pattern. https://research.google/blog/amie-a-research-ai-system-for-diagnostic-medical-reasoning-and-conversations/
- **NeMo Guardrails (Rebedea et al., arXiv:2310.10501)** offers a DSL for topic/style/dialogue restrictions. https://arxiv.org/abs/2310.10501
- Common patterns in digital health literature (seen in PH-LLM/AMIE and recommended by Anthropic for agents): (i) *scope guard* — a list of out-of-scope topics (chest pain, cardiac symptoms, pregnancy, acute injury) that force termination with referral; (ii) *standard disclaimer* on any output containing a prescription; (iii) *hard limits* on volume/intensity (10%/week rule is classical sports-training literature); (iv) *human-in-the-loop* as recommended by the MCP spec itself for actions with side effects (https://modelcontextprotocol.io/introduction).

## 4. Poorly designed feedback loop — pitfalls

- **Sycophancy (Sharma et al., Anthropic, arXiv:2310.13548, 2023, rev. 2025)** shows that RLHF preference models prefer agreeing responses even when wrong. Directly applicable: if athlete feedback is "loved the workout", the model learns to prescribe what the athlete *likes*, not what makes them *improve*. https://arxiv.org/abs/2310.13548
- **Wei et al. (arXiv:2308.03958)** shows that sycophancy worsens with scale and instruction tuning, and that light fine-tuning with synthetic data reduces it. https://arxiv.org/abs/2308.03958
- **GPT-4o April/2025 incident** — the model became excessively agreeing after an RLHF update based on thumbs-up; OpenAI reverted. Real evidence of reward hacking in a user feedback loop (blocked by the harness but widely documented; see technical coverage on Simon Willison and others).
- Concrete mitigations: (a) separate *satisfaction* from *outcome* (adherence + objective performance: power, TSS, PB) — only the second goes into the update; (b) *reward shaping* including diversity / progression / load; (c) *counterfactual eval* — a sample of sessions where a judge asks "if followed to the letter, does this improve the athlete?"; (d) periodic human review of stratified sampling.

## 5. Versioning LLM systems

- **Langfuse** — automatic versions per prompt, labels like "production"/"staging", eval per dataset tied to each version, client-side cache. Canary via label pattern. https://langfuse.com/docs/prompts/get-started
- **LangSmith** — offline eval (curated dataset, regression testing) + online eval (LLM-as-judge on real traffic with sampling), pairwise comparison to promote a version. https://docs.langchain.com/langsmith/evaluation
- **MLflow Prompt Registry** — "Git-inspired commit-based versioning", mutable alias (e.g., "production" points to version N), integrated with MLflow Tracing/Evaluation, differential cache (immutable version = infinite; alias = 60s TTL). Most natural fit if already on Databricks. https://mlflow.org/docs/latest/genai/prompt-registry/
- Consolidated pattern: **semver for prompts (major = breaking output schema; minor = instruction improvement; patch = fix)**, "prod"/"canary" alias, mandatory eval-gate before promotion, versioned regression dataset alongside.
- Version *everything* — not just the prompt: retrieval config (top-k, threshold, embedding model), tool schema, RAG base (snapshot with hash), model id/params. Databricks Unity Catalog + MLflow allows tying it all in the same run.

## 6. Evaluating AI coaching systems

- **Do not use BLEU/ROUGE** — consensus already in Gao et al. survey and ARES. Poor for open-ended generation.
- **Offline** — LLM-as-judge (Databricks Mosaic AI: answer correctness, groundedness, retrieval relevance, safety, with written rationale). https://www.databricks.com/blog/announcing-mosaic-ai-agent-framework-and-agent-evaluation — ARES (arXiv:2311.09476) for faithfulness. Dataset curated by an expert (human coach) with golden cases.
- **Periodic human eval** — Anthropic recommends 20-30 initial cases; humans catch bias that automation misses. PH-LLM used 857 case studies with expert rubric.
- **Online** — adherence, retention, and above all *outcome* (change in FTP, CTL/ATL, weekly TSS, PBs). Behavioral metrics (thumbs) are a *weak proxy* — per topic 4, use only as UX signal, not technical quality.
- **Stratify** by athlete profile (beginner/intermediate/advanced) — aggregate quality hides bugs in subgroups.

## 7. RAG with asymmetric sources

- **Multiple retrievers + fusion is the dominant pattern.** Gao et al. survey describes this as "Modular RAG". Pinecone advanced-RAG covers RAG Fusion with Reciprocal Rank Fusion (RRF). https://www.pinecone.io/learn/advanced-rag-techniques/
- **Router LLM** to decide *which* retriever to consult first: cheap when the sources are very distinct (athlete tables vs. literature). Anthropic "Building Effective Agents" describes routing as a formal pattern.
- **GraphRAG (Edge et al., 2024)** for "cohort" queries (e.g., "athletes with my profile, what tends to work?") — a graph over athlete/workout/adaptation entities helps in an aggregate question where pure vector fails.
- Practical recommendation: **one retriever per source + unified reranker + RRF fusion**. Structured (athlete): direct SQL/Delta via MCP, not vector. Cohort: vector on profile embeddings + metadata filters. Literature: vector on paper chunks.
- Warning: never mix different embedding spaces in a single index. Use separate retrieval and reconcile in the reranker.

## 8. MCP in production

- **MCP spec (Anthropic, 2024)** — open standard, initial integrations Google Drive, Slack, GitHub, Git, Postgres, Puppeteer. https://www.anthropic.com/news/model-context-protocol / https://modelcontextprotocol.io/introduction
- **Databricks MCP** — Databricks published (2025) managed MCP servers on Unity Catalog / Genie / Vector Search to expose private data to Claude and other MCP clients (could not fetch the exact blog URL, but the product is published). If building on Databricks, this is the canonical path.
- **Known security risks** (Simon Willison, Apr/2025 and Invariant Labs): prompt injection via *tool descriptions* (tool poisoning), *rug pull* (server changes definition after install), *tool shadowing* (malicious server overrides trusted tool), *confused deputy*. https://simonwillison.net/2025/Apr/9/mcp-prompt-injection/
- Practices: (a) install only verified MCP servers; (b) show tool descriptions to the user; (c) least-privilege scope in Unity Catalog; (d) mandatory human-in-the-loop for writes; (e) never give the same agent simultaneous access to sensitive private data + open internet without sandbox.

## 9. Published AI coach cases

- **Google PH-LLM (arXiv:2406.06474, 2024)** — fitness/sleep coaching with wearable data; parity with experts on fitness MCQ. But the authors say more eval is needed before production.
- **Google AMIE (2024)** — diagnostic dialogue with self-play and critic feedback; not coaching, but the eval framework is transferable.
- **WHOOP Coach** — publicly announced on OpenAI; no paper with detailed architecture (could not access WHOOP URL, returned 403). Treat as marketing.
- **Strava / Fitbit AI** — announced features, no public architecture found.
- General signal: **no comparable system has published architecture + results rigorously**. That is both opportunity and risk — few playbooks to copy.

## 10. Known production failures

- **Barnett et al., "Seven Failure Points When Engineering a RAG System" (arXiv:2401.05856, 2024)** — abstract confirms 7 modes, with key conclusions: "validation is only feasible during operation" and "robustness evolves rather than designed in at the start". https://arxiv.org/abs/2401.05856. Frequently cited modes (from the paper and ecosystem): missing content, top-k miss, not-in-context, wrong format, incorrect specificity, wrong answer despite retrieval, citation escape.
- **Anthropic multi-agent post-mortem**: redundant sub-agents due to vague task description; agents continuing after having an answer; SEO bias in sources; info loss in multi-stage. https://www.anthropic.com/engineering/built-multi-agent-research-system
- **Tool-call loops** — agent calling the same tool repeatedly. Mitigation: hard limit of N calls per tool, repetition detector in the orchestrator, global timeout.
- **Context overflow** — passing all retrieval to the generator overflows the window. Mitigations: rerank + compress + select small top-k; intermediate summarization; Databricks Mosaic Agent Framework has tracing to measure this.
- **Latency** — multi-agent is expensive; Anthropic explicitly says "use multi-agent only when justified". Prompt caching and tool-call parallelization are the two biggest wins.
- **Hallucination under pressure** (bad context, short time) — mitigate with a mandatory graceful "no answer" in the schema (allow `insufficient_evidence: true`).

---

## Hype vs. validated practice

- **Validated**: basic RAG + reranker; LLM-as-judge combined with human eval; prompt versioning; structured output for citation; scope guards in health.
- **Emerging with evidence**: Self-RAG, CRAG, GraphRAG, orchestrator-workers multi-agent, Databricks MCP.
- **Hype — treat with skepticism**: "100% autonomous agent solves everything"; "RLHF on user feedback improves the model" (the opposite is the default risk); "vector search as single source solves it"; "WHOOP/Strava did it and it works" (no paper, no evidence).

---

## Synthesis: 5 concrete recommendations for the design

1. **Adopt the topology "router → N retrievers → reranker → generator with Self-RAG-style critique → CitationAgent"**, not autonomous multi-agent. Router LLM decides between (a) MCP to the athlete's Delta Tables (structured data, SQL), (b) Vector Search for amateur cohort (profile embeddings + metadata filters), (c) Vector Search for literature (paper chunks). Unified reranker + RRF fuse results. Generator produces output with a strict schema that includes `claims[].source_id` validated; CitationAgent post-processes and rejects claims without a valid source.

2. **Harden the feedback loop against sycophancy/reward-hacking.** Explicitly separate satisfaction (thumbs, chat) from outcome (delta in FTP, adherence, CTL/ATL progression, PBs). Only outcome + adherence enter the fine-tuning/eval dataset; satisfaction serves UX telemetry. Add periodic counterfactual judge ("does this prescription maximize progress or comfort?"). Audit stratified sampling by profile.

3. **Explicit and tested health guardrails.** Define a closed list of red flags that force termination with referral to a professional (chest pain, unexpected dyspnea, acute injury, neurological symptoms, pregnancy without clearance, known cardiac condition). Implement as NeMo Guardrails or a separate classifier before the generator; do not rely on prompt alone. Standard disclaimer on any prescription. Hard limits on weekly load delta.

4. **Version everything in MLflow (Databricks-native) with a mandatory eval-gate.** Prompt semver, prod/canary aliases, RAG base snapshot with hash, embedding model version, retrieval config, tool schemas — all in the same MLflow run. Never promote without passing: (i) regression dataset curated by a human coach; (ii) LLM-as-judge (Mosaic AI) on groundedness/safety/correctness; (iii) canary at 5-10% of traffic for N days with adherence monitoring.

5. **Instrument known failures from day 1.** Traces with Databricks Mosaic Agent Framework, tool-call loop detection (limit N, watchdog), mandatory `insufficient_evidence` field in the schema (lets Claude say "I don't know" instead of hallucinating), least-privilege MCP tool scope via Unity Catalog, human-in-the-loop for any *write* (workout logging, plan change). Never give the same agent MCP + open web in the same session with athlete data — confused-deputy risk.

---

## Main sources

- Anthropic. "Building Effective Agents" (2024). https://www.anthropic.com/engineering/building-effective-agents
- Anthropic. "How We Built Our Multi-Agent Research System" (2025). https://www.anthropic.com/engineering/built-multi-agent-research-system
- Anthropic. "Introducing the Model Context Protocol" (2024). https://www.anthropic.com/news/model-context-protocol
- Gao et al. "Retrieval-Augmented Generation for LLMs: A Survey" arXiv:2312.10997 (2024).
- Asai et al. "Self-RAG" arXiv:2310.11511 (2023).
- Yan et al. "Corrective RAG (CRAG)" arXiv:2401.15884 (2024).
- Edge et al. "GraphRAG" arXiv:2404.16130 (Microsoft Research, 2024).
- Singh et al. "Agentic RAG Survey" arXiv:2501.09136 (2025).
- Sharma et al. "Towards Understanding Sycophancy in Language Models" arXiv:2310.13548 (Anthropic, 2023 rev. 2025).
- Wei et al. "Simple Synthetic Data Reduces Sycophancy" arXiv:2308.03958 (2023).
- Cosentino et al. "Personal Health LLM (PH-LLM)" arXiv:2406.06474 (Google, 2024).
- Tu et al. "AMIE" (Google Research, 2024). https://research.google/blog/amie-a-research-ai-system-for-diagnostic-medical-reasoning-and-conversations/
- Rebedea et al. "NeMo Guardrails" arXiv:2310.10501 (2023).
- Saad-Falcon et al. "ARES" arXiv:2311.09476 (2023).
- Barnett et al. "Seven Failure Points When Engineering a RAG System" arXiv:2401.05856 (2024).
- Willison. "MCP Prompt Injection" (2025). https://simonwillison.net/2025/Apr/9/mcp-prompt-injection/
- Databricks. "Mosaic AI Agent Framework and Agent Evaluation". https://www.databricks.com/blog/announcing-mosaic-ai-agent-framework-and-agent-evaluation
- Langfuse Docs, Prompt Management. https://langfuse.com/docs/prompts/get-started
- LangSmith Evaluation Docs. https://docs.langchain.com/langsmith/evaluation
- MLflow Prompt Registry. https://mlflow.org/docs/latest/genai/prompt-registry/
- Pinecone. Advanced RAG Techniques. https://www.pinecone.io/learn/advanced-rag-techniques/
