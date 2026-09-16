# System Design — watts-up-coach

Living design document. Records the current state of design decisions for the training-prescription agent, updated as research and brainstorming produce new evidence. Each decision cites the research file that supports it, so the "why" stays traceable.

References:
- `docs/premises.md` — evidence-quality premise.
- `docs/research/cycling-training-science.md` — original physiology reference.
- `docs/research/training-science-extended.md` — peer-reviewed expansion (HR-only, behavior, noise, exclusions, elite methods).
- `docs/research/coaching-tools-market-scan.md` — market survey (10 platforms).
- `docs/research/coaching-tools-market-scan-addendum.md` — market survey extension.
- `docs/research/agentic-rag-patterns.md` — agentic RAG, MCP, feedback loop, versioning.

Captured: 2026-09-16.

## 1. Purpose and scope

**Purpose.** Provide daily adaptive training prescription and on-demand reports to an amateur cyclist, grounded on the athlete's own data, comparable amateur cohorts and peer-reviewed literature. The system exists both to be useful in real training and to be a real-world Databricks learning ground for the author.

**In scope.** Daily prescription; on-demand analytical reports with charts; Intervals.icu workout format as prescription output; conversational input (wellness, feedback, restrictions); scientific citations on every prescription.

**Out of scope.** Medical advice; real-time in-workout coaching; commercial product; support for multiple sports beyond road cycling in phase 1.

## 2. Design principles

1. **Evidence over opinion.** Any physiology/health claim carries a peer-reviewed citation or a "not peer-reviewed" tag (`docs/premises.md`).
2. **Grounded synthesis.** Every prescription cites which data, which cohort comparison, and which literature drove it. Claude is a synthesizer, not an oracle (agentic-rag-patterns §2).
3. **Adaptation is continuous, not scheduled.** Each request rebuilds the picture from current data. The system has no "pending alert" state.
4. **Satisfaction is not outcome.** User feedback about how nice a workout felt informs UX telemetry, never the training model (agentic-rag-patterns §4).
5. **Fail loudly, not silently.** When evidence is missing, the system says "insufficient evidence" instead of guessing (agentic-rag-patterns §10).
6. **Start simple.** Orchestrator-workers, not autonomous multi-agent (agentic-rag-patterns §1).

## 3. System overview

```
┌─────────────────────────────────────────────────────────────────┐
│                     Athlete (chat, workouts)                    │
└──────────────────────────┬──────────────────────────────────────┘
                           │
                Claude (via MCP)  ── orchestrator
                           │
     ┌─────────────────────┼─────────────────────────┐
     │                     │                         │
Router LLM ── decides which retriever to consult
     │                     │                         │
┌────▼─────┐         ┌─────▼──────┐          ┌───────▼────────┐
│ Athlete  │         │ Amateur    │          │ Scientific     │
│ MCP      │         │ cohort     │          │ literature     │
│ (Delta)  │         │ Vector     │          │ Vector Search  │
│          │         │ Search     │          │ (peer-reviewed │
└────┬─────┘         └─────┬──────┘          │ RAG corpus)    │
     │                     │                 └───────┬────────┘
     └─────────────────────┼─────────────────────────┘
                           │
                     Reranker + fusion (RRF)
                           │
                    Generator (Claude)
                           │
                CitationAgent (post-process)
                           │
                ┌──────────┴────────────┐
                │                       │
     Prescription (Intervals.icu    On-demand report
     workout format) + rationale    + charts
                │
        Optional API push to
        Intervals.icu (Phase 2)
```

Ingestion (Intervals.icu → Delta) and cohort embedding refresh are separate scheduled workloads outside the request-time path.

## 4. Data layer

**Storage.** Delta Lake on Databricks Free Edition (serverless), governed by Unity Catalog. Two logical layers only — no medallion at this scale.

- **Raw layer.** Append-only, one table per data source (Intervals.icu workouts, Intervals.icu wellness, athlete self-report). JSON payloads preserved verbatim to allow reprocessing when schemas evolve. Columns: `athlete_id`, `ingested_at`, `payload`, source-specific keys.
- **Curated layer.** One table per analytical concept (workouts, wellness_daily, load_metrics, capacity_metrics, feedback). Typed schemas, cleaned, deduplicated, keyed by `athlete_id + timestamp`.

**Multi-athlete isolation.** Column `athlete_id` on every table. No row-level policies in phase 1. Cohort queries operate over anonymized aggregates.

**Catalog choice.** Deferred (`workspace` default vs dedicated `watts_up_coach`). Neither blocks the design.

## 5. Athlete input model

Based on `training-science-extended.md` §2 (behavior) and §3 (noise variables), and `cycling-training-science.md` §5 (subjective feedback).

**Ingested every session from Intervals.icu.**

- Power (if available), HR, duration, elevation, cadence.
- Derived: TSS, IF, NP, TRIMP variants, decoupling (HR-power drift).

**Athlete self-report — daily / event-driven.**

- Morning wellness (4 items, Hooper-style, 1-5): sleep quality, fatigue, muscle soreness, motivation.
- Post-workout: sRPE (Foster CR-10), free-text feedback ("how was it").
- Weekly: body weight (used as 7-day rolling mean, per Bradshaw 2024).
- Life context: available hours, illness/injury flags, upcoming stressors.

**Athlete profile — updated on change.**

- Goal + target event with date.
- Restrictions (time windows, mandatory rest days, injuries).
- Measured HRmax (from incremental test; theoretical 220 − age is rejected per training-science-extended §4).
- Power meter availability (drives HR-only fallback path).
- **Context anchor** — typical time-of-day and location of training. Feeds the habit-formation model (Kaushal & Rhodes 2015, `training-science-extended.md` §2): repetition in a cue-consistent setting is a stronger predictor of habit strength than motivation. The prescription engine tries to keep prescriptions consistent with the anchor and flags proposals that would break it.

**Mandatory onboarding assessments (Premise 3).**

- PAR-Q+ (Warburton et al. 2011). Any positive answer routes to ePARmed-X+ or medical clearance before prescription starts.
- ACSM pre-participation algorithm (Riebe et al. 2015, *MSSE*, PMID 26473759).
- ESC leisure-athlete criteria for men > 35 with cardiovascular risk factors (Corrado et al. 2011, PMID 21278396).

**Periodic assessments — every 12 weeks (Premise 3).**

- REDs CAT2 three-step check (Mountjoy et al. 2023 *BJSM*, PMID 37752011).
- OSTRC overuse questionnaire (Clarsen et al. 2013 *BJSM*, PMID 23038786).

**Every 4 weeks.**

- Self-Report Habit Index (SRHI, 12 items, Verplanken & Orbell 2003, *J Appl Soc Psychol* 33(6):1313). Tracks habit-strength trajectory against the Kaushal & Rhodes target (4 sessions/week for 6+ weeks in a stable context).

**Explicitly not ingested (excluded by premise + peer-review evidence).**

- Single-day resting HR (Buchheit 2014).
- Isolated spot urine USG (Cheuvront 2015).
- Proprietary composite scores (Body Battery, Xert Strain, Whoop Recovery number) as decision variables — their raw HRV / sleep inputs are ingested, the score is not.
- Generic free-text "how are you today?" without a validated instrument.
- Daily body weight as a trigger (only as 7-day rolling mean).

## 6. Prescription engine

**Topology.** Orchestrator-workers (agentic-rag-patterns §1). Claude orchestrates; a router LLM decides which retrievers to fire per request; a CitationAgent post-processes the answer to validate all cited sources exist. No autonomous multi-agent loop.

**Retrievers.**

- **Athlete retriever** — SQL / Delta over the curated layer via MCP. Structured data; never routed to Vector Search.
- **Cohort retriever** — Vector Search over amateur-only profile embeddings (age, weight, W/kg, weekly volume, goal, history summary), with metadata filters. Elite / pro data is excluded from the cohort by construction (user premise: amateur cohort only).
- **Literature retriever** — Vector Search over the peer-reviewed RAG corpus. Sources must pass `docs/premises.md` filter at ingestion time.

Reranker + Reciprocal Rank Fusion unify results. Top-k is trimmed before it reaches the generator to protect the context window.

**Adaptation factors weighted per request** (all four are inputs, weighting evolves per §9 versioning):

1. Fitness / fatigue model — CP + W' from the power-duration curve where power is available; PMC (CTL/ATL/TSB) as a visualization layer only, not as a hard readiness gate (training-science-extended §1, `cycling-training-science.md` §1).
2. Last executed session — intensity, duration, adherence to prescription, RPE.
3. Today's wellness score — Hooper 4-item, weekly HRV trend (ln rMSSD, 7-day mean per Plews 2013/2014), acute vs chronic load ratio (Gabbett ACWR).
4. Periodization phase — distance to target event, base / build / specific / taper.

**HR-only mode.** When no power meter is present, the engine drops CP + W' and reweights toward: HR zones anchored on measured HRmax, Karvonen where appropriate, TRIMP for load, sRPE as primary daily load metric (Sanders 2017, Bourdon 2017). Prescription vocabulary shifts from "target 240W" to "target HR zone 3 for 20 min at RPE 6/10".

**Environmental adjustments.** Altitude, heat, humidity flagged in the athlete input. At altitude, absolute power targets drop; HR + RPE become primary. In heat, cardiac drift is expected and interpreted as thermal signal, not fatigue.

**Output format.** Intervals.icu workout syntax. Rationale block appended with:
- Data snapshot used (CTL, HRV weekly trend, last-session load, days to target).
- Cohort comparison (when available).
- Peer-reviewed citation(s) supporting the choice of stimulus.
- **GRADE-aligned evidence tier per rationale line** (Premise 2 — high / moderate / low / very low), including the qualified-coach tier (Premise 5) when a coach synthesis backs the claim.
- **Directness qualifier.** HR-only prescriptions for amateur cyclists in tropical conditions default to at most `moderate` (extrapolation from temperate / power-based studies) unless a peer-reviewed source directly matches the context.
- `insufficient_evidence: true` block when no tier ≥ `low` supports the claim.
- **BCT tag** (Michie et al. 2013, *Ann Behav Med* 46:81, PMID 23512568) — which behaviour-change technique the prescription uses (goal setting, self-monitoring, feedback on performance, social support are the cycling-relevant ones per Bird et al. 2013, *Health Psychol* 32:829, PMID 23477577). Enables later audit of which BCTs correlate with outcome.

**Delivery.** Phase 1: chat with the athlete pushes the workout block for copy-paste. Phase 2: automated push to Intervals.icu via their API. Falls back gracefully if the API path fails.

## 7. Feedback loop

**Two disjoint tracks** (Premise 6 — long-term progression over short-term satisfaction; agentic-rag-patterns §4 — sycophancy mitigation).

- **Outcome track.** Fed by executed load vs prescribed, delta on FTP / CP / durability metrics, personal bests, target-event performance, injury/illness absence. Only this track informs future prescription models and evaluation datasets.
- **Satisfaction track.** Fed by conversational sentiment, thumbs, comments. Used strictly for UX telemetry — never merged into training features.

When the tracks disagree — the athlete loved a workout that peer-reviewed evidence says is under-stimulating for their phase — the engine prescribes what the evidence supports and explains why in the rationale. This is Premise 6 in action, not a design detail.

**No-punishment rule for missed sessions.** A single missed day does not affect the habit trajectory (Lally et al. 2010, *Eur J Soc Psychol* 40:998, DOI 10.1002/ejsp.674). The 46 % intention–behaviour gap is normal (Rhodes & de Bruijn 2013, *Br J Health Psychol* 18:296, PMID 23480428). Adherence is not tracked as a streak or a punishment — the engine restores the plan smoothly, and only sustained deviation (multiple weeks below 4 sessions per Kaushal & Rhodes 2015 target) triggers an adaptation review.

**BCT audit.** The BCT tags emitted on each prescription (see §6) feed a periodic audit that correlates BCTs used with outcome deltas — which techniques produce results for this athlete, which do not.

**Text feedback ("today felt heavy, left leg tight").** Parsed by Claude into structured signals (localized fatigue flag, RPE inference, adherence flag). Structured signals go to the outcome track; the raw text is stored for auditability.

**Counterfactual audit.** Periodically, a separate judge run asks "does this prescription maximize progression or maximize comfort?" over a stratified sample. Findings feed the versioning process, not runtime.

## 8. Safety guardrails

Sourced from Premise 3 (safety scope), agentic-rag-patterns §3, and training-science-extended §2 (Meeusen 2013 overtraining consensus, Schwellnus 2016 IOC illness consensus).

**Red-flag scope guard.** The full red-flag list is defined in Premise 3. The engine runs the classifier upstream of the generator; a hit produces a fixed deferral response ("this needs a qualified professional; here are the next steps: ...") and blocks the normal prescription path. Prompt-only guardrails are not sufficient.

**Load hard limits.** Weekly load delta capped (order-of-magnitude 10% rule as a starting point). Acute:chronic load ratio kept in the 0.8-1.3 band (Gabbett 2016). Requests to break these are refused with an explanation.

**Standard disclaimer.** Every prescription includes a short statement that the system is a training assistant, not medical advice.

**MCP boundaries** (agentic-rag-patterns §8).

- Least-privilege scope in Unity Catalog: MCP tools only see athlete tables of the requesting athlete.
- Never grant an MCP tool and open web access to the same session over athlete data (confused-deputy risk).
- Any write action (workout logging, plan mutation, Intervals.icu API push) requires an explicit human-in-the-loop confirmation until Phase 2 hardening.

## 9. Metrics and versioning

**Success metrics** (three, none is adherence).

- Subjective positive feedback — trend of "makes sense" reports.
- Objective evolution — FTP / CP / watts-per-kg / durability / target-event outcome.
- Prediction accuracy — when the system predicts ("today you'll feel X"; "your CTL in 14 days will be Y"), how close the observed value falls.

Benchmarks are dynamic: as the RAG corpus grows and outcome data accumulates, "expected" recalibrates.

**Versioning.** Every mutation to prompt, MCP tool schema, retrieval config, embedding model, or RAG corpus hash is captured as an MLflow run (agentic-rag-patterns §5). Prompts are semver-tagged (major = output schema break; minor = instruction improvement; patch = fix). Aliases `prod` and `canary` point at chosen versions. No promotion without passing:

1. Regression on a coach-curated golden dataset.
2. LLM-as-judge scores (Mosaic AI Agent Evaluation) for groundedness, safety, correctness.
3. Optional canary window before full promotion.

Project semver (`CLAUDE.md` §4, `CHANGELOG.md` when it exists) tracks system-level releases; prompt semver is separate and finer-grained.

## 10. Multi-athlete evolution

**Cohort composition rule.** Amateurs only. Elite / pro data is excluded from cohort comparisons by construction. When the second athlete is added, cohort features begin — profile similarity, comparable response patterns — following the closest publicly validated analog (Manresa-Rocamora 2021 on HRV-guided personalization).

**Privacy.** Data isolation by `athlete_id` is enough for phase 1. When onboarding a second real athlete, add explicit consent and anonymization of cohort embeddings.

## 11. Open items (still deferred)

- Catalog choice (`workspace` vs dedicated `watts_up_coach`).
- Test framework (pytest, Nutter, other).
- Definition-of-done per phase in the roadmap.
- Exact Intervals.icu workout token format (verified when ingestion begins).
- Free Edition quotas on Model Serving endpoints and Vector Search (verified in workspace).
- Fueling / nutrition ingestion (Precision Fuel & Hydration is a candidate partner per market addendum).

## 12. Evidence gaps we accept

Five sub-domains where peer-reviewed evidence is thin or absent (Premise 2a). The system labels claims in these areas as `low` or `very low` and does not overclaim:

- Uncertainty communication in exercise prescription.
- Formal elite → amateur extrapolation rules.
- Adherence measurement resilient to legitimate life events.
- Sycophancy as a formal construct in digital coaching (analogy via engagement quality — Torous 2018 / Baumel 2019 / Mohr 2017).
- Adherence predictors for a 12-week amateur cycling plan specifically.

In these gaps the system collects its own longitudinal data and treats it as `low` tier until enough accumulates to inform an internal cohort observation (still tagged `low`, never elevated to consensus).

## 13. Delta vs previous design

New or changed decisions produced by the second research pass:

- **Peer-review premise formalized** (`docs/premises.md`) — new project-wide rule.
- **HR-only prescription path** added as a first-class mode (previously implicit).
- **Body weight** treated as a 7-day rolling mean (Bradshaw 2024), not a daily point.
- **Theoretical HRmax rejected**; measured HRmax required.
- **Environmental adjustments** (altitude, heat) explicit in the prescription engine.
- **Life stress and habits** promoted from soft context to first-class inputs (Teixeira 2012 SDT, Kaushal & Rhodes 2015 habits).
- **Durability** (Jones 2024) added to the tracked capacity set for amateurs targeting 2-6h events.
- **Cohort excludes elite / pro data** by construction.
- **Race modeling** (physics-based race split, à la BestBikeSplit) noted as a future differentiation angle in market addendum §synthesis.
- **Post-session rebuild** (TrainAsONE benchmark) noted as the bar to meet for "truly adaptive".
- **Sycophancy separation** hardened: outcome vs satisfaction as disjoint tracks, with counterfactual audit.
- **CitationAgent post-processing** replaces "citation in prompt" pattern (Anthropic multi-agent research 2025).
- **MCP boundaries** made explicit (least-privilege UC scope, no MCP + open-web co-existence, human-in-loop for writes).
