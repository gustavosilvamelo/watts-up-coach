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

**Rule.** When the prescription engine assembles an answer from multiple sources, every claim in the output carries an **evidence-quality tag** aligned with the GRADE framework (Guyatt et al. 2008, *BMJ* 336:924, PMID 18436948; Balshem et al. 2011, *J Clin Epidemiol* 64(4):401, PMID 21208779):

- **High** — a consensus statement, systematic review, or convergent RCTs that apply directly to amateur cyclists.
- **Moderate** — peer-reviewed evidence that requires modest extrapolation (elite → amateur, adjacent sport → cycling, or single well-conducted study without replication).
- **Low** — a single peer-reviewed study, cohort observational data from the system's own athletes (n >> 1) with clearly reported size and heterogeneity, or qualified-coach synthesis referencing peer-reviewed work.
- **Very Low** — expert opinion, individual athlete history (n = 1), or model inference without a cited source. Very-low claims are allowed only as narrative connective tissue, never as the basis for a training decision.

**Applicability caveat.** GRADE was developed for clinical guidelines and has not been formally validated for individualized coaching prescription (no peer-reviewed paper does so). We adopt the tier structure as an accountability scaffold, not as a claim of GRADE compliance.

**Why.** Without a hierarchy, an n = 1 pattern in the athlete's history can override peer-reviewed consensus, and a cohort of three amateurs can overrule a systematic review. That silently degrades the quality guarantee Premise 1 was written to protect. Kawamoto et al. 2005 (*BMJ* 330:765, PMID 15767266) systematic review of clinical decision-support systems shows that surfacing recommendation rationale is a key success factor.

**Enforcement.** Prescription output includes an `evidence` block per rationale line, listing the tier and citation. When multiple tiers back the same claim, all are listed. When only `low` or `very low` backs a claim, the output says so explicitly.

## 2a. Evidence gaps we accept and label honestly

The second research pass surfaced five sub-domains where peer-reviewed evidence is thin or absent. The system does not fabricate consensus in these areas — it labels claims as `very low` or `low`:

- **Uncertainty communication in exercise prescription** — no validated framework specific to amateur endurance sport.
- **Formal elite → amateur extrapolation rules** — no position statement covers this transition.
- **Adherence measurement resilient to legitimate life events** — no peer-reviewed framework; design principle draws from Lally et al. 2010 (a single missed day does not affect habit trajectory) and Rhodes & de Bruijn 2013 (46% intention–behaviour gap is normal).
- **Sycophancy in digital coaching** — the term is not used in peer-reviewed sport-science literature; the analogy is "engagement quality vs quantity" (Torous et al. 2018, *Evid Based Ment Health* 21:116, PMID 29871870; Baumel et al. 2019, *JMIR* 21(9):e14567, PMID 31573916; Mohr et al. 2017, *Psychiatr Serv* 68:427, PMID 28196461).
- **Adherence predictors for a 12-week amateur cycling plan specifically** — no peer-reviewed dataset; the system must collect its own longitudinal evidence and treat it as `low` tier until it accumulates.

## 3. Safety scope

**Rule.** The system is a training assistant, not medical advice. Safety is enforced by validated screening instruments applied at onboarding and periodically, plus a fixed red-flag list that triggers deferral to a qualified health professional.

**Onboarding screening — mandatory.**

- **PAR-Q+** (Warburton, Jamnik, Bredin, Gledhill 2011, *Health & Fitness Journal of Canada* 4(2):3-17; validation Bredin et al. 2013, *Can Fam Physician* 59(3):273, PMID 23486800). Any positive answer routes to ePARmed-X+ or medical clearance before prescription begins.
- **ACSM pre-participation algorithm** (Riebe et al. 2015, *MSSE* 47(8):2473, PMID 26473759): current activity level + presence of CV/metabolic/renal disease + signs/symptoms decides whether medical clearance is required before moderate or vigorous exercise.
- **ESC criteria for masters / leisure athletes** (Corrado et al. 2011, *European Heart Journal* 32(8):934, PMID 21278396): for men > 35 with cardiovascular risk factors, history + physical exam + 12-lead ECG clearance recommended.

**Periodic screening — every 12 weeks.**

- **REDs CAT2** simplified (Mountjoy et al. 2023, *BJSM* 57(17):1073, PMID 37752011): three-step check (screening → severity → deferral) applicable to athletes at any level, including recreational.
- **Overuse injury check** — OSTRC questionnaire (Clarsen et al. 2013, *BJSM* 47(8):495, PMID 23038786).

**Red-flag deferral list — peer-reviewed backing.**

- Chest pain during exercise, unexplained syncope, sustained palpitations, disproportionate dyspnea, family history of sudden death < 50 yr (Corrado et al. 2011, PMID 21278396; Marijon et al. 2015 *Circulation* 131:1384, PMID 25847988).
- Acute injury requiring diagnosis.
- Pregnancy without written physician clearance.
- Known cardiac condition without endurance-activity clearance.
- REDs signal cluster: rapid weight loss, restrictive eating, amenorrhea, persistent fatigue with anhedonia (Mountjoy et al. 2023, PMID 37752011; Sundgot-Borgen & Torstveit 2004 *Clin J Sport Med* 14:25, PMID 14712163; Karrer et al. 2023 *Sports (Basel)* 11(3):52, PMID 36976938).
- Anything the athlete describes that the system cannot classify with at least `low`-tier evidence per Premise 2.

**Why.** The literature on AI health advice systems (`docs/research/agentic-rag-patterns.md` §3) converges on a fixed red-flag list plus mandatory referral. Prompt-only guardrails are insufficient — the check must run upstream of generation.

**Enforcement.** A classifier or ruleset runs before the generator. A red-flag hit produces a fixed deferral response and blocks the normal prescription path. Every non-red-flag prescription still includes a short standard disclaimer.

## 4. RAG corpus governance

**Rule.** A peer-reviewed source enters the scientific literature RAG corpus only through a defined ingestion path with recorded provenance, quality filters at ingestion, and periodic retraction checks. The corpus and the RAG chain are versioned as separate artifacts; every prescription records which corpus version was grounded on.

**Ingestion path.**

1. Candidate paper identified — manual selection or scheduled `esearch` + `efetch` via NLM E-utilities against Premise 1's journal allowlist (https://www.nlm.nih.gov/dataguide/eutilities/what_is_eutilities.html).
2. **Quality filters at ingestion** (reject unless all pass):
   - Journal indexed in PubMed **or** SCOPUS **or** Web of Science **or** DOAJ (whitelist).
   - DOI resolves via Crossref.
   - Journal not on Cabell's Predatory Reports / community-maintained Beall's list mirror (blacklist).
3. Provenance captured per chunk: `document_id`, `chunk_id`, `source_url`, `author`, `journal`, `publication_date`, `ingestion_timestamp`, `embedding_model_version`, `chunk_hash`, `evidence_tier` (per Premise 2), `qualified_professional_tier` (per Premise 5 when applicable).
4. **Chunking rule.** Preserve the abstract as one atomic chunk (never split). Use structural chunking on body sections (arXiv:2504.19754 on structural chunking of scientific papers). Adopt Anthropic Contextual Retrieval (contextual embeddings + BM25 + reranker, https://www.anthropic.com/engineering/contextual-retrieval) — reported to cut retrieval failures ~49 %.
5. Corpus snapshot hashed. RAG chain registered in the MLflow Model Registry under Unity Catalog with semver aliases `@dev` / `@staging` / `@prod`. Chain and corpus versions are separate artifacts and are joined per prescription record.

**Nightly retraction check.** For every DOI in the corpus, query `api.crossref.org/works/[DOI]` and inspect the `update-to` / `relation` fields for retraction or correction notices. Retracted chunks are soft-deleted (flagged `retracted=true`, kept for audit).

**Exclusion path.** A source is removed from active retrieval when it is retracted, corrected in a way that invalidates the used claims, or superseded by a systematic review the corpus already contains. Removal is recorded, not silent.

**Audit cadence.** Corpus content is reviewed at least once per project semver minor release. A weekly job runs corpus-level evaluation (coverage against a curated sub-question bank, median document age, author/institution diversity — arXiv:2410.15531) and blocks promotion on regression.

**MCP boundary — lethal-trifecta rule (Willison 2025, https://simonwillison.net/2025/Jun/16/the-lethal-trifecta/).** Never combine, in the same session, all three of: (a) private athlete data access, (b) untrusted external content ingestion, and (c) external-communication tools. At least one must be absent. This constrains how MCP tools are wired to the RAG.

**Why.** Without governance, "peer-reviewed only" degrades in practice: a predatory-journal paper slipped through, a preprint mislabeled, or a retracted paper still cited — each silently violates Premise 1.

## 5. Qualified professional — definition and tiering

**Rule.** For Premise 1's "qualified health, performance, coaching or physical-education professional" clause, credentials are classified into three tiers. Content is only considered qualified-coach synthesis when its author holds at least one credential at Medium or High tier, or has documented peer-reviewed authorship in a Premise 1 journal.

**High tier — accept as qualified-coach synthesis without further gating.**

- Academic: PhD or MSc in exercise physiology, sports science, sports medicine, or exercise psychology.
- Clinical / physiology: ACSM Certified Exercise Physiologist (ACSM-CEP), CSEP-CEP, BASES Accredited Practitioner (SEPAR route).
- Strength & conditioning: NSCA CSCS combined with a cycling-specific Level 2 / 3 credential.
- Cycling-specific: UCI Level 3 Diploma (World Cycling Centre, Aigle), USA Cycling Level 1, British Cycling Level 3.
- Peer-reviewed authorship of at least one Premise 1-tier article.

**Medium tier — accept with citation, mark as qualified-coach synthesis at Premise 2 `low` evidence tier.**

- Academic: bachelor's in exercise science + relevant certification.
- Physiology: ACSM Certified Exercise Physiologist (ACSM-EP) alone, CSEP-CPT, NSCA CSCS alone.
- Cycling-specific: USA Cycling Level 2, British Cycling Level 2, AusCycling Coach (senior), CBC Nível I combined with active CREF registration.

**Low tier — insufficient for a training claim on its own. Content may only be used as narrative connective tissue, tagged `very low`.**

- Cycling-specific entry: USA Cycling Level 3, British Cycling Level 1, AusCycling Community Instructor.
- Platform accreditation: TrainingPeaks University Level 1 / 2, CTS Certified Coach.
- Generic personal training: NASM, ACE, ISSA — not cycling-specific and no clinical exercise physiology component.

Content by anyone without any of the above — regardless of following, popularity, or self-declared credentials — does not qualify.

**Why.** Without a definition, "qualified professional" is a hole through which any self-declared coach can enter the evidence base. This is the exact failure mode Premise 1 exists to prevent. The tiering makes the trade-off explicit and reviewable.

## 6. Long-term progression over short-term satisfaction

**Rule.** When designing feedback signals, evaluation metrics, and default prescriptions, the system optimizes for **long-term physiological progression, adherence to a plan the athlete believes in, and target-event outcomes** — never for short-term satisfaction alone.

Concretely:

- Satisfaction (thumbs, sentiment) is captured for UX telemetry only. It never enters training features, fine-tuning data, or evaluation datasets.
- Outcome (delta on CP / FTP / durability, target-event performance, injury/illness absence) is the training and evaluation signal.
- When the two disagree — the athlete loved a workout that peer-reviewed evidence says is under-stimulating — the system prescribes what the evidence supports and explains why.

**Why.** `docs/research/agentic-rag-patterns.md` §4 documents that reward hacking on user satisfaction is the default failure mode of feedback loops (Sharma 2023 on sycophancy; GPT-4o April/2025 incident). The digital-mental-health literature reaches the same conclusion under a different name — "engagement quality vs quantity" (Torous et al. 2018, *Evid Based Ment Health* 21:116, PMID 29871870; Baumel et al. 2019, *JMIR* 21(9):e14567, PMID 31573916; Mohr et al. 2017, *Psychiatr Serv* 68:427, PMID 28196461). Making the value explicit at the premise level prevents accidental "let's use thumbs to fine-tune" moves downstream.

## 7. (reserved for future premises)
