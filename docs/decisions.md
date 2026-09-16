# Decision Log

Chronological log of load-bearing project decisions. Newest entries at the top. Each entry states the decision, why it was made, and the sources or evidence that back it. Reversals are appended as new entries — history is never rewritten.

---

## 2026-09-16 — Deep-research refinement of premises 2-6

**Trigger.** After committing the first cross-analysis (premises 2 through 6 in `docs/premises.md`) a deep-research pass was launched with two agents to find peer-reviewed and vendor-technical backing for the questions the analysis had opened. Both agents returned dense, verifiable content.

**Sources ingested into this refinement.**

- Agent A (peer-reviewed only, evidence tier + guardrails + habit formation): GRADE framework (Guyatt 2008; Balshem 2011), PAR-Q+ and ePARmed-X+ (Warburton 2011; Bredin 2013), ACSM pre-participation update (Riebe 2015), ESC leisure-athlete screening (Corrado 2011), sports SCA epidemiology (Marijon 2015), REDs CAT2 (Mountjoy 2023), disordered eating in endurance (Sundgot-Borgen 2004; Karrer 2023), overuse injury instrument (Clarsen 2013 OSTRC), habit formation (Kaushal & Rhodes 2015; Lally 2010; SRHI Verplanken & Orbell 2003), intention–behaviour gap (Rhodes & de Bruijn 2013), BCTv1 (Michie 2013; Bird 2013), detraining (Coyle 1984; Mujika 2000), engagement vs outcome (Torous 2018; Baumel 2019; Mohr 2017).
- Agent B (mixed sources for engineering; official sites for certifications): USA Cycling / British Cycling / UCI / AusCycling / CBC certification structure; ACSM-CEP, CSEP-CEP, BASES, NSCA CSCS clinical certifications; Databricks Vector Search + Unity Catalog governance patterns; Retraction Watch via Crossref API; PubMed E-utilities ingestion; predatory-journal filters (Cabell's, Beall's lists); Anthropic Contextual Retrieval (49 % retrieval-failure reduction); MLflow model registry semver aliases; Willison's lethal-trifecta rule (private data + untrusted content + external-communication tools).

**Refinements applied.**

- **Premise 2** rewritten to align with the GRADE 4-tier structure (high / moderate / low / very low) with the applicability caveat that GRADE has not been validated for individualized coaching. Added §2a naming the five sub-domains where peer-reviewed evidence is thin (uncertainty communication, elite-to-amateur extrapolation, adherence resilience, digital sycophancy, cycling-specific amateur adherence predictors) — these are labeled `low` or `very low` and never as consensus.
- **Premise 3** now names the validated screening instruments (PAR-Q+, Riebe/ACSM 2015, Corrado/ESC 2011, REDs CAT2, OSTRC) and cites peer-reviewed backing for every red-flag.
- **Premise 4** now specifies the ingestion path (NLM E-utilities), the ingestion-time quality filters (PubMed/SCOPUS/Web of Science/DOAJ allowlist + Cabell's/Beall's blacklist + Crossref DOI resolution), chunking rules (atomic abstract, structural chunking, Anthropic Contextual Retrieval), the MLflow-based versioning strategy, the nightly Retraction Watch check via Crossref API, and the MCP lethal-trifecta rule.
- **Premise 5** rewritten as a three-tier map (High / Medium / Low) with named certifications and the rule that Low-tier content may only be used as narrative connective tissue (`very low` evidence).
- **Premise 6** now cites Torous 2018 / Baumel 2019 / Mohr 2017 as the digital-mental-health analogue to sycophancy.
- **Design §5** gained mandatory PAR-Q+ / ACSM / ESC onboarding, REDs and OSTRC quarterly, SRHI monthly.
- **Design §6** output format now emits GRADE-aligned evidence tiers and BCT tags (Michie 2013), with an explicit directness qualifier for the tropical amateur HR-only case.
- **Design §7** gained the no-punishment rule (Lally 2010; Rhodes & de Bruijn 2013) and the periodic BCT audit.
- **Design §12** (new) lists the five accepted evidence gaps openly, mirroring Premise 2a.

**Why this batch and not more.** The refinements stop at concrete instruments and tier mappings. Runtime orchestration details (retrieval pipeline shape, retriever weights, evaluation harness) are left to implementation. The premises now have enough grip to prevent silent quality drift without turning into a runbook.

---

## 2026-09-16 — Cross-analysis of premises against research

**Trigger.** After completing the second research pass (`training-science-extended.md`, `coaching-tools-market-scan-addendum.md`), a review of Premise 1 (evidence quality) against the accumulated research and design surfaced concrete gaps.

**Gaps found.**

1. RAG corpus governance is undefined. Premise 1 says what counts as evidence but not how a paper enters the corpus, how provenance is captured, or when a retracted source is removed.
2. Evidence hierarchy at inference time is unstated. The engine mixes peer-reviewed literature, cohort observational data, and individual (n = 1) data without ranking. An n = 1 pattern could silently override a systematic review.
3. Safety scope ("not medical advice", red-flag deferral) lived inside `docs/design.md` §8 — an implementation section — but is a value-level rule about system boundaries and belongs at the premise level.
4. "Qualified professional" clause of Premise 1 had no operational definition; any self-declared coach could technically satisfy it.
5. "Optimize progression over satisfaction" was implicit in the feedback-loop design but not stated as a premise, leaving the anti-sycophancy value exposed to accidental drift later.
6. Habit formation (Kaushal & Rhodes 2015) was cited in the research but had no design touchpoint — the strongest behavioral predictor of adherence was not being collected.
7. Confidence tiering absent from the output format. Peer-review evidence for HR-only prescription in tropical amateurs is thin (`training-science-extended.md` §1 gap note) but the design did not carry that uncertainty to the prescription.

**Decisions.**

- Added Premises 2 through 6 in `docs/premises.md`:
  - Premise 2 — evidence hierarchy at inference time.
  - Premise 3 — safety scope and red-flag deferral rules.
  - Premise 4 — RAG corpus governance (ingestion path, provenance, exclusion, audit cadence).
  - Premise 5 — operational definition of "qualified professional" (degrees + certifications + peer-reviewed authorship).
  - Premise 6 — long-term progression over short-term satisfaction as an explicit optimization target.
- Design updated:
  - `docs/design.md` §5 gained a "context anchor" input to feed the habit-formation model.
  - `docs/design.md` §6 output format now emits an evidence-tier tag, a confidence level, and an `insufficient_evidence` block.
  - `docs/design.md` §7 feedback-loop text now points to Premise 6 as the reason for the two-track separation, and states what happens when tracks disagree.
  - `docs/design.md` §8 safety guardrails now defer to Premise 3 rather than duplicating the red-flag list.

**Why not simply amend Premise 1.** Premise 1 governs "what counts as evidence at all". Governance, hierarchy at inference, safety scope, professional definition, and optimization value are distinct concerns; folding them into Premise 1 would blur its scope and make review harder.

**Follow-up (open).** A deep-research pass was launched on the questions surfaced by the analysis:

- Evidence-tier methodology in health decision-support (GRADE and analogs).
- Adherence measurement without punishment — behavior science / digital health.
- Habit-formation instruments applicable to endurance sport (concrete surveys and behavioral tags).
- RAG corpus governance patterns in health knowledge bases (curation, provenance, refresh).
- Professional certification landscape in cycling coaching (validates Premise 5).

Findings will be committed as subsequent entries in this log.
