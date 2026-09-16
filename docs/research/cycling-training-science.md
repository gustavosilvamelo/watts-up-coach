# Cycling Training Science — Research Reference

Reference notes on data and metrics relevant for prescribing training to an **amateur cyclist**, gathered during system design. Prioritizes recent evidence (2020+) and consensus vs. debated positions. Sources are cited at each claim; a consolidated list appears at the end.

Captured: 2026-09-16.

## 1. Load metrics: is CTL/ATL/TSB still the standard?

- **PMC (Coggan) is still the industry default** in TrainingPeaks / Intervals.icu / WKO, but is increasingly framed as a **retrospective visualization tool, not a predictive model**. Consensus in coaching press (Roadman, TrainingPeaks coach blog 2024-25) is that PMC "shows what you did", not "what you can do".
- **Documented weaknesses**: (a) TSS collapses everything to NP + FTP + duration, so a 300 TSS Z2 ride is treated ~= 300 TSS with 40 min VO2 work; (b) time constants (42/7 days) are population averages, not personalized; (c) TSB has weak evidence as a race-readiness predictor.
- **Banister fitness-fatigue impulse-response**: the original math is fine, but Hellard et al. and Busso have shown poor future-performance prediction and instability of parameters when fit to individual athletes (PMC1974899, "Assessing the limitations of the Banister model"). Recent work extends it to 3-dimensional impulse-response (arXiv 2503.14841, 2025) but is still research-grade.
- **Skiba's xPower / BikeScore / dCTL**: uses a 25s exponentially-weighted average (vs. Coggan's 30s rolling) anchored on CP rather than FTP. Same PMC shape, arguably better physiological grounding, but small user base outside GoldenCheetah. No large validation study.
- **Xert's "Training Load" / Strain / MPA**: proprietary; not peer-reviewed. Marketing, not literature.
- **HRV-guided load**: growing evidence base (see §3) — best treated as a **modulator** on top of a planned load, not a replacement for it.
- **For amateurs**: consensus in coaching literature (Friel, CTS Time-Crunched, Roadman 2025-26) is that **absolute CTL ceiling is life-limited (~70-100 for most)** and ramp rate matters more than the number. Recommendation for the agent: keep PMC as a display / bookkeeping layer, do NOT use TSB as a hard readiness signal — combine with HRV + RPE + wellness (well-supported downstream in §3 and §5).

## 2. Intensity and capacity metrics: FTP vs LT2 vs MLSS vs CP + W'

- **These are NOT interchangeable** even when correlated. Recent evidence:
  - Karsten et al., *IJSPP* / related PMC7862708: CP and FTP correlate r ~0.97 but **limits of agreement are wide enough to be meaningful** (>90% chance of a meaningful difference in an individual).
  - Jamnick, Botella, Pyne & Bishop (2020, *Sports Med*), widely cited critique: FTP is **not a valid surrogate for MLSS or LT2**.
  - PMC8220144 (recreational cyclists) shows LT2 markers correlate strongly with CP but wide LoA.
- **Practical differences**:
  - **FTP**: performance-derived (20 min × 0.95 or ramp × 0.75). Cheap, repeatable at home, biased by anaerobic contribution and pacing.
  - **CP + W'**: derived from ≥2 maximal efforts across the power-duration curve. Physiologically the heavy/severe boundary; W' quantifies suprathreshold capacity.
  - **LT2 / MLSS**: gold standard but require lab lactate testing.
- **For amateurs**: PMC10448799 (junior cyclists) shows the "60-min sustainable" assumption behind FTP applies mainly to trained/elite riders; amateurs typically fail well before an hour, so FTP overestimates the true sustainable steady state.
- **Design recommendation**: use **CP + W' (from 3-min-all-out + 12-min or similar)** if you can extract multiple maximal efforts from historical rides (Intervals.icu already does this). Retain FTP as a UI/legacy anchor. Consider tracking **durability** (Maunder 2021, *Sports Med*; recent frameworks *J Appl Physiol* 2025) — the decline of CP / power at a given HR after e.g. 2000 kJ. Amateurs need durability more than raw FTP for events >2 h.

## 3. HRV and readiness

- **Consensus is warming, not fully settled.** Best current evidence:
  - **Vesterinen et al. (2016), *Scand J Med Sci Sports***: first well-cited RCT — HRV-guided training beat pre-planned in recreational runners for 3000 m TT.
  - **Düking et al., Javaloyes et al. (2018-2020)**: replicated in cyclists / runners.
  - **Systematic review + meta-analysis: Manresa-Rocamora et al. (2021), *Sports Medicine* (PMID 34639599)**: HRV-guided training produces **small-to-medium benefit on VO2max and submaximal indices vs pre-planned**, with better effect in **amateurs and females** than elites.
  - Narrower meta (PMC7663087, 2020): small positive effect on VO2max.
  - Recent (PMC12485039, 2025) in experienced cyclists: HRV-, HR- and wellness-guided prescriptions all viable; no single winner.
- **rMSSD (7-day rolling mean and CV)** is the accepted metric. Morning supine 60s reading, or nocturnal average (Whoop / Oura) — both work, but **do not mix devices**: nocturnal and morning have systematic offsets (Plews & Buchheit).
- **Device validity**:
  - **HRV4Training vs ECG**: r 0.77-0.94, "trivial differences" (Plews 2017; Moya-Ramón et al. 2022).
  - **WHOOP**: reasonable, but higher day-to-day noise (PMC9505647, 2022 Olympic water polo).
  - **Garmin HRV Status** (nightly, since 2022, Firstbeat-based): promising but few independent validations.
- **For amateurs, actionable rule** (Kiviniemi/Plews style): use **7-day rMSSD baseline**; if today < baseline − 0.5·SD (or CV rising) → swap intensity for Z2 or rest. Do not react to a single day.

## 4. Training zones: 3, 5, or 7?

- All coexist and describe the same physiology at different resolutions:
  - **3-zone (Seiler)**: below VT1 / VT1-VT2 / above VT2. Used for TID (training intensity distribution) research.
  - **5-zone (Coggan)** and **7-zone (Friel)**: prescription resolution.
- **The TID debate is still live**:
  - **Foster, Casado, Esteve-Lanao, Haugen, Seiler (2022), *MSSE***: "Polarized Training Is Optimal for Endurance Athletes" — argues 80/20 polarized.
  - **Burnley, Bearden, Jones (2022, rebuttal)**: "Polarized training is not optimal" — points out most elites train pyramidally, not polarized.
  - **Meta-analyses**: Rosenblat et al. (2019, PDF 325492365; updated 2024 *Sports Med*, link.springer.com/article/10.1007/s40279-024-02034-z) — polarized slightly favored over threshold, but **vs pyramidal the difference is trivial**. IJSPP 2023 systematic review of trained cyclists shows pyramidal is more common in-season.
- **For amateurs**: Seiler himself has said the 80/20 rule was derived from athletes doing ≥8-10 h/week. For time-crunched (<6 h) amateurs, **pyramidal / threshold-heavy actually works** (see the classic time-crunched literature and CTS). Recommendation: default to pyramidal in-season for amateurs <8 h, polarized in base for those >10 h.

## 5. Subjective feedback (RPE, wellness)

- **Session-RPE (Foster 2001)** is the most-validated single subjective load tool — >950 citations; multiple systematic reviews (Haddad et al. 2017, PMC5673663) confirm validity vs HR-based TRIMP and power-based TSS across sports and levels.
- **Wellness questionnaires**:
  - **Hooper Index** (sleep quality, fatigue, stress, muscle soreness, 1-7): validated, decades-old, cheap.
  - **DALDA** (Rushall): daily analysis of life demands.
  - **POMS / brief POMS**: mood; more research than field use.
  - **Saw, Main, Gastin (2016), *BJSM***: landmark review — **subjective measures respond to acute and chronic training loads with superior sensitivity and consistency than objective measures**. The strongest single argument for weighting wellness heavily.
- **For amateurs**: sRPE × duration for load, plus a 4-question morning wellness (sleep quality, fatigue, muscle soreness, motivation, 1-5) is the highest-ROI subjective package. Combine with HRV — Bourdon et al. (2017 supplement of *IJSPP*, monitoring position stand) endorses this combined approach.

## 6. Recovery factors: sleep, nutrition, stress

- **Sleep**: Halson (2014, *Sports Med* review "Monitoring training load..."; 2013 sleep review) is the canonical reference. Actigraphy (or wrist-based sleep tracking) + self-report is the field standard. Total sleep time and sleep efficiency are the reliable signals.
- **Life stress**: **Stults-Kolehmainen & Sinha (2014), *Sports Medicine***: psychosocial stress impairs recovery and increases injury risk. Otter et al. running injury cohort found perceived stress predicted injury.
- **Nutrition**: energy availability (EA, kcal·kg FFM⁻¹·day⁻¹) — Mountjoy et al. IOC REDs consensus (2018, 2023 update, *BJSM*): below 30 kcal·kg⁻¹·day⁻¹ suppresses adaptation. For amateurs, coarse fueling tracking (pre/during/post ride carbs) is realistic; full EA is not.
- **Practical**: sleep hours + sleep quality (1-5) + life-stress (1-5) are the three self-report items with the best cost/signal ratio. Objective sleep from wearables adds signal but not much beyond self-report for amateurs.

## 7. Device data — signal vs. noise

- **Reliable (signal)**: power (crank/pedal-based, ±1-2%), HR from chest strap, GPS distance/elevation, cadence, sRPE input, sleep duration/efficiency from wrist device.
- **Moderate**: nocturnal HRV (Whoop/Oura/Garmin), wrist optical HR at low-moderate intensity, elevation from barometer, temperature.
- **Noisy (be skeptical)**:
  - **Garmin/Firstbeat VO2max**: MAE 3-5 ml/kg/min with chest strap, 5-8 with wrist optical. Undershoots highly trained by 2-4 points (BMC study on Forerunner 245, PMC12881131). Useful as a **trend**, not a number.
  - **Body Battery / Training Readiness / Stress**: proprietary composites, no independent peer-reviewed validation. Directionally useful, not a decision variable.
  - **Wrist optical HR during intervals**: known dropouts.
  - **Strava "fitness/freshness"**: same PMC math on estimated power for non-power users — heavily biased.
- **Emerging**: **decoupling / cardiac drift** (Pw:HR) as a durability proxy (Front. AI 2025, PMC12271085 — ML on cardiac drift predicts responder status, k = 0.86-0.93). Muscle O2 (Moxy) is research-grade for amateurs. Continuous glucose in endurance is early — no strong prescription evidence yet.

## 8. Published predictive models

- **Response to training (responder vs non-responder)**:
  - **Bouchard HERITAGE Family Study (1999)**: 47% of VO2max trainability is heritable; ~7% of trained subjects were true non-responders. Foundational.
  - **Ross et al. (2019), *Mayo Clin Proc***: individual response is real but shrinks when training dose is individualized (Bonafiglia, Gurd et al. work).
  - **Frontiers in AI 2025 (PMC12271085)**: ML on cardiac drift classifies responders (accuracy 0.86-0.93 across kNN / logistic / VGP). Small n, cycling-specific.
  - **Scientific Reports 2025** (nature.com/articles/s41598-025-25369-7): ML personalization of pyramidal vs polarized TID for marathon; four responder clusters.
- **Overtraining prediction**: no strong, cross-validated, published ML model that generalizes. Meeusen et al. (2013 ECSS/ACSM overtraining consensus, *MSSE*) is still the reference framework; monitoring combines HRV, mood (POMS), performance decrement, resting HR.
- **FTP / performance forecasting**: TrainerRoad claims ML on 250M activities (marketing, unpublished). Academic side: power-duration modeling (Morton, Skiba) can project TT performance from CP + W' with reasonable error for well-controlled TTs.
- **Recovery prediction**: PMC11519101 (*Eur J Appl Physiol* 2024) — ML predicting daily recovery over long-term endurance training; uses HRV + subjective + load; small cohorts, promising but not deployable out-of-the-box.

## 9. Cohort and "similar athletes"

- **Published academic work is thin.** The commercial platforms (TrainerRoad Adaptive Training, Xert, Humango, Athletica) publish white papers/blogs but few peer-reviewed pieces.
- **TrainerRoad**: their Adaptive Training uses a workout-level pass/fail classifier + Progression Levels; they claim ML across ~250M activities. No peer-reviewed publication; road.cc and Cyclingnews coverage is descriptive.
- **Athletica (Prof. Paul Laursen)**: closer to peer-reviewed heritage; based on published HIIT science (Buchheit & Laursen 2013 *Sports Med* two-part HIIT review).
- **Academic analog**: matrix-factorization / collaborative filtering approaches exist in the sports-analytics literature but are largely proprietary. If you need to cite, HRV-guided personalization literature (Manresa-Rocamora 2021) is the closest publicly-validated equivalent to "individualize based on similar athletes' responses".

## 10. Amateur vs. elite — adjustments

- **Volume is the biggest gap**: most elite TID / HRV-guided studies use athletes at 8-20 h/week. Amateurs are often at 4-8 h. Seiler has publicly acknowledged that **80/20 is derived from high-volume athletes**; below ~8 h/week, more time at threshold (pyramidal / threshold) is defensible (Muñoz et al., Stöggl & Sperlich 2014 in *Frontiers*).
- **Life stress dominates**: amateurs' recovery variance is driven by sleep and work stress more than by intra-training factors — the coaching model must ingest wellness inputs, not just training load. Roadman/CTS/Friel converge on this.
- **Data density is lower**: fewer lab tests, no regular lactate, less compliance with morning HRV. Design must tolerate missing data (imputation, default to conservative prescription).
- **Higher inter-individual variability in trainability** in amateurs is expected (HERITAGE data). The non-responder rate is meaningful — the agent should detect stagnation early and change stimulus (Bonafiglia et al. — retrospective analysis of individual responses to interval training).
- **Durability matters more than FTP** for typical amateur target events (gran fondo, century, 3-6 h). Track power-at-HR drift over ride duration.
- **Injury / illness risk**: acute:chronic workload ratio (Gabbett 2016 *BJSM*) is the most-cited safety heuristic — keep the 7-day / 28-day load ratio around 0.8-1.3.

## Things NOT found with good evidence (be honest)

- A **peer-reviewed, cross-validated ML model for overtraining prediction** in cyclists that generalizes beyond the training set.
- Independent validation of **Garmin Training Readiness / Body Battery / Xert Training Load** in peer-reviewed literature.
- A **published cohort-based "similar-athlete" recommender** with prospective RCT evidence in cycling.
- Direct RCT evidence for **HRV-guided training in low-volume amateur cyclists specifically** (most RCTs use runners or trained cyclists ≥8 h/week; recreational studies exist but are heterogeneous).

## Concrete design implications for the agent

1. Ingest: power, HR, duration, elevation, sRPE, morning wellness (4 items), morning or nocturnal rMSSD, sleep hours + quality.
2. Track: CP + W' (rolling from PD curve), FTP as display, PMC as visualization, decoupling / durability as an emerging feature, ACWR for safety.
3. Modulate a planned pyramidal (default for <8 h) or polarized (default for ≥10 h) plan with a **daily readiness score** = weighted combo of rMSSD 7-day deviation + wellness + sRPE trend. Follow the Kiviniemi/Vesterinen decision rule (reduce or swap intensity when readiness is low).
4. Detect non-response (~4-6 wk of no CP progression + no durability progression) and switch stimulus.
5. Do **not** treat proprietary composite scores (Body Battery, Xert Strain, Whoop Recovery number) as ground truth; use their raw HRV / sleep inputs directly.
6. Weight subjective inputs heavily — Saw et al. 2016 remains the strongest single piece of evidence that self-report often beats gadgets.

## Key sources

- Foster et al. 2001, *J Strength Cond Res* — session-RPE.
- Foster, Casado, Esteve-Lanao, Haugen, Seiler 2022, *MSSE* — polarized training.
- Burnley, Bearden, Jones 2022 (rebuttal in *MSSE*).
- Jamnick, Botella, Pyne, Bishop 2020, *Sports Medicine* — FTP is not MLSS.
- Karsten et al. (PMC7862708) — CP vs FTP 20-min test.
- Muriel-Herrera et al. (PMC8220144) — CP vs LT2 in recreational cyclists.
- Manresa-Rocamora et al. 2021, *Sports Medicine* (PMID 34639599) — meta-analysis of HRV-guided training.
- Vesterinen et al. 2016, *Scand J Med Sci Sports* — HRV-guided RCT.
- Plews, Laursen, Stanley, Kilding, Buchheit 2013, *Sports Medicine* — HRV in elites.
- Plews et al. 2017 — HRV4Training validation.
- Halson 2014, *Sports Medicine* — monitoring training load.
- Saw, Main, Gastin 2016, *BJSM* — subjective vs objective monitoring.
- Bourdon et al. 2017, *IJSPP* supplement — monitoring position stand.
- Meeusen et al. 2013 ECSS/ACSM overtraining consensus, *MSSE*.
- Bouchard et al. 1999, *J Appl Physiol* — HERITAGE.
- Bonafiglia, Gurd et al. — individual response literature.
- Maunder et al. 2021, *Sports Medicine* — durability definition; *J Appl Physiol* 2025 durability framework.
- Mountjoy et al. 2018/2023, *BJSM* — REDs / energy availability.
- Gabbett 2016, *BJSM* — acute:chronic workload ratio.
- Frontiers AI 2025 (PMC12271085) — ML cardiac drift for responder classification.
- Skiba GoldenCheetah source — xPower / BikeScore implementation.
- Meta-analyses on TID: Rosenblat et al. 2019/2024, *Sports Medicine*; IJSPP 2023 systematic review of trained cyclists.
- Buchheit & Laursen 2013, *Sports Medicine* — HIIT programming.
