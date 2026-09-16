# Decision Log

Chronological log of load-bearing project decisions. Newest entries at the top. Each entry states the decision, why it was made, and the sources or evidence that back it. Reversals are appended as new entries — history is never rewritten.

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
