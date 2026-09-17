# docs — index

Navigation map for all project documentation. Each document has a defined scope; cross-references are explicit links rather than duplicated content.

---

## Foundational documents

| Document | Scope | Status |
|---|---|---|
| [premises.md](premises.md) | Load-bearing rules that apply across the whole project. Governance for evidence quality, safety, RAG corpus, professional credentials, and optimization target. | Active — 6 premises |
| [design.md](design.md) | Full system design: inputs, prescription format, adaptation loop, RAG grounding, monitoring, feedback, versioning. | Active — 12 sections |
| [decisions.md](decisions.md) | Append-only log of every load-bearing decision: what was decided, why, and what evidence backed it. | Active |

---

## Infrastructure

| Document | Scope | Status |
|---|---|---|
| [infrastructure.md](infrastructure.md) | Environment map (Databricks Free Edition, AWS), vector search options, S3 integration, Terraform scope, and learning goals for each area. | Active |

---

## Research

Background research that informed design and premises. Read-only after the research phase closes.

| Document | Scope |
|---|---|
| [research/cycling-training-science.md](research/cycling-training-science.md) | Peer-reviewed training science: PMC metrics, CP/W′, durability, HRV, sRPE, polarisation, ACWR. |
| [research/training-science-extended.md](research/training-science-extended.md) | Extended pass: BIA monitoring, adherence instruments, habit formation, evidence gaps. |
| [research/coaching-tools-market-scan.md](research/coaching-tools-market-scan.md) | Competitive landscape: 10 platforms mapped, gaps identified. |
| [research/coaching-tools-market-scan-addendum.md](research/coaching-tools-market-scan-addendum.md) | Addendum: 15 additional platforms, new signals (BestBikeSplit race modeling, TrainAsONE adaptive benchmark, Final Surge free tier). |
| [research/agentic-rag-patterns.md](research/agentic-rag-patterns.md) | Agentic RAG architecture patterns, sycophancy risks, MCP guardrails, evaluation strategy. |

---

## How to add a document

1. Create the file under the appropriate folder (`docs/` or a sub-folder).
2. Add a row to the table above with scope and status.
3. If the document records a decision, add an entry to `decisions.md`.
4. Docs are in English. Conversation with the user is in Portuguese (`CLAUDE.md` §3).
