# Project Premises

Load-bearing rules that apply across the whole project. New premises are appended over time; premises are only removed or amended by explicit decision.

## 1. Evidence quality (training, physiology, health)

**Rule.** For any decision that touches training prescription, physiology, biomechanics, health, sports psychology, nutrition, or recovery, the only content that counts as evidence is peer-reviewed literature published in journals with recognized standing, or material produced or endorsed by qualified health, performance, coaching, or physical-education professionals whose content itself references and synthesizes peer-reviewed literature.

**Why.** The system prescribes training and generates guidance a real athlete will act on. Content pulled from marketing, opinion, or unverified sources can be wrong in ways that harm the athlete or degrade trust in the system. Peer review is not perfect, but it is the strongest publicly available quality filter for physiological claims.

### Accepted sources

- Peer-reviewed articles in journals such as *Sports Medicine*, *Medicine & Science in Sports & Exercise (MSSE)*, *British Journal of Sports Medicine (BJSM)*, *Journal of Applied Physiology*, *European Journal of Applied Physiology*, *International Journal of Sports Physiology and Performance (IJSPP)*, *Scandinavian Journal of Medicine & Science in Sports*, *Frontiers in Physiology*, *Journal of Strength and Conditioning Research*, *Sports Health*, *Journal of Sports Sciences*.
- Position stands and consensus statements from recognized bodies (ACSM, IOC, ECSS, ESC).
- Systematic reviews and meta-analyses indexed in PubMed / PMC.
- Peer-reviewed conference proceedings only when clearly cited by journal literature.
- Books authored by qualified professionals (physiologists, physicians, certified coaches, physical-education academics) when the specific claim referenced is itself backed by peer-reviewed literature.

### Rejected sources

- Blog posts, forum posts, social media threads, videos, and podcasts — regardless of author.
- Product marketing pages, vendor white papers, and platform help centers.
- Popular-science magazines and newspapers without peer review.
- Preprints (arXiv, bioRxiv, medRxiv) unless later published and cited by peer-reviewed work.
- Any source that cannot be attributed to a qualified professional in health, performance, coaching, or physical education.

### Out of scope

This premise does **not** apply to:

- Software engineering, AI/ML architecture, MCP protocol, and RAG patterns — these are governed by industry practice and legitimately rely on arXiv preprints, engineering blogs, and platform documentation. Sources for those topics are captured in `docs/research/agentic-rag-patterns.md` with their trade-offs stated.
- Commercial platform surveys (`docs/research/coaching-tools-market-scan.md`) — necessarily rely on vendor sites; peer-review is not available for such content.

### Enforcement

- Every physiology/training claim added to project documents, prompts, or the RAG corpus must carry a citation that meets the accepted-source criteria above.
- A non-compliant claim must be either replaced with a compliant citation or explicitly labeled `not peer-reviewed` and marked for later substitution.
- Documents in `docs/research/` are periodically audited against this premise; the audit result is recorded in the same document.

## 2. Evidence hierarchy at inference time

**Rule.** When the prescription engine assembles an answer from multiple sources, sources are ranked by evidence quality and every claim in the output carries the tier of the source that supports it. From highest to lowest:

1. **Peer-reviewed literature** meeting Premise 1.
2. **Qualified-coach synthesis** meeting Premise 1 (books, position statements by certified professionals that reference peer-reviewed work).
3. **Cohort observational data** — patterns extracted from the amateur cohort in the system's own tables. Sample size and heterogeneity are always reported.
4. **Individual athlete data** (n = 1) — the athlete's own history. High personal relevance but low external validity.
5. **Model inference** — pattern completion by the LLM without a cited source. Only allowed for narrative connective tissue, never as the basis of a training claim.

**Why.** Without a hierarchy, an n = 1 pattern in the athlete's history can override a peer-reviewed consensus, and a cohort of 3 amateurs can overrule a systematic review. That silently degrades the quality guarantee Premise 1 was written to protect.

**Enforcement.** Prescription output includes an `evidence` block per rationale line, listing the tier and citation. When multiple tiers back the same claim, all are listed. When only tier 4 or 5 backs a claim, the output must say so explicitly.

## 3. Safety scope

**Rule.** The system is a training assistant, not medical advice. It stops and defers to a qualified health professional whenever any of the following red flags appears in athlete input or in ingested data:

- Chest pain, unexpected dyspnea, syncope, or new neurological symptoms.
- Acute injury requiring diagnosis.
- Pregnancy without written clearance from a physician.
- Known cardiac condition without medical clearance for endurance activity.
- Sustained resting HR elevation, unexplained weight loss, or amenorrhea patterns consistent with REDs (Mountjoy et al. 2023, IOC consensus) — deferral, not diagnosis.
- Anything the athlete describes that the system cannot classify with peer-reviewed backing.

**Why.** The literature on AI health advice systems (`docs/research/agentic-rag-patterns.md` §3) converges on a fixed red-flag list plus mandatory referral. Prompt-only guardrails are insufficient — the check must run upstream of generation.

**Enforcement.** A classifier or ruleset runs before the generator; a red-flag hit produces a fixed deferral response and blocks the normal path. Every non-red-flag prescription still includes a short standard disclaimer.

## 4. RAG corpus governance

**Rule.** A peer-reviewed source enters the scientific literature RAG corpus only through a defined ingestion path with recorded provenance. The corpus is versioned; every prescription records which corpus version it was grounded on.

**Ingestion path.**

1. Candidate paper identified (manually or through a scheduled query against PubMed / PMC / journal RSS feeds within Premise 1's accepted journal list).
2. Provenance captured: DOI or PMID, journal, year, authors, ingestion timestamp, ingested-by (human or automated job).
3. Full text (or abstract + methods) chunked and embedded.
4. Metadata recorded includes evidence tier per Premise 2 (systematic review > cohort > case study > editorial).
5. Corpus snapshot hashed and versioned in MLflow.

**Exclusion path.** A source is removed from the corpus when it is retracted, corrected in a way that invalidates the claims used, or when a superseding meta-analysis is added. Removal is recorded, not silent.

**Audit cadence.** Corpus content is reviewed at least once per project semver minor release.

**Why.** Without governance, "peer-reviewed only" degrades in practice: a preprint slipped in during a busy week, or a retracted paper still cited, silently violates Premise 1.

## 5. Qualified professional — definition

**Rule.** For Premise 1's "qualified health, performance, coaching or physical-education professional" clause, a qualifying credential is at least one of:

- Terminal degree in exercise physiology, sports medicine, sports science, physical therapy, medicine (MD/DO), physical education, or nutrition (MSc, PhD, MD).
- Active certification from an established professional body: ACSM (Certified Exercise Physiologist, Registered Clinical Exercise Physiologist), NSCA (CSCS), USA Cycling (Level 1-3), British Cycling (Level 3 Diploma), CTS Certified Coach, or equivalent national body.
- Documented and peer-recognized authorship of at least one peer-reviewed article in a journal listed in Premise 1.

Content by anyone else — regardless of following, popularity, or self-declared credentials — does not qualify.

**Why.** Without a definition, "qualified professional" is a hole through which any influencer marketing themselves as a coach can enter the evidence base. This is the exact failure mode Premise 1 exists to prevent.

## 6. Long-term progression over short-term satisfaction

**Rule.** When designing feedback signals, evaluation metrics, and default prescriptions, the system optimizes for **long-term physiological progression, adherence to a plan the athlete believes in, and target-event outcomes** — never for short-term satisfaction alone.

Concretely:

- Satisfaction (thumbs, sentiment) is captured for UX telemetry only. It never enters training features, fine-tuning data, or evaluation datasets.
- Outcome (delta on CP / FTP / durability, target-event performance, injury/illness absence) is the training and evaluation signal.
- When the two disagree — the athlete loved a workout that peer-reviewed evidence says is under-stimulating — the system prescribes what the evidence supports and explains why.

**Why.** `docs/research/agentic-rag-patterns.md` §4 documents that reward hacking on user satisfaction is the default failure mode of feedback loops (Sharma 2023 on sycophancy; GPT-4o April/2025 incident). Making the value explicit at the premise level prevents accidental "let's use thumbs to fine-tune" moves downstream.

## 7. (reserved for future premises)
