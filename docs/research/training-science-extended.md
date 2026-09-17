# Training Science — Extended Peer-Reviewed Reference

Expansion of `cycling-training-science.md` requested during system design. Focus areas: heart-rate-only prescription, motivational and behavioral factors, noise variables, variables to exclude, and methods used by elite / World Tour cyclists.

**Source-quality rule (project premise, `docs/premises.md`).** This document lists only peer-reviewed articles from journals with recognized standing. Marketing pages, blog posts, forum content, videos, opinion pieces and unpublished preprints were rejected as evidence. Where the peer-review literature is thin or absent, the gap is stated explicitly rather than filled with lower-quality sources.

Captured: 2026-09-16.

## 1. Heart-rate-only prescription (no power meter)

- **Internal load monitoring — consensus.** Bourdon et al. 2017, *IJSPP* position stand (PMID 28463642): HR, sRPE and TRIMP are valid endurance monitoring methods, with recommendation levels varying by context. Consensus.
- **TRIMP variants and sRPE agree in cycling.** Sanders et al. 2017, *IJSPP* (PMID 28095061): Banister TRIMP, Lucia TRIMP, Edwards TRIMP and sRPE show moderate-to-high agreement in road cyclists; sRPE has the lowest cost and adequate concurrent validity.
- **sRPE — origin and robustness.** Foster 1998, *MSSE* (PMID 9662690) is the origin; Haddad et al. 2017, *Frontiers in Neuroscience* (PMID 29163016) systematic review: sRPE is robust to age, sex and modality, but timing of collection matters (>30 min post-session is ideal). Consensus.
- **%HRR vs %HRmax anchoring.** Vehrs, Tafuna'i & Fellingham 2022 and older Scharff-Olson et al. 1992 show that Karvonen (%HRR) tends to underestimate true VO2 at lower intensities. Active debate about which anchoring best individualizes zones.
- **HR–power decoupling / cardiac drift as a fatigue signal.** Rothschild et al. 2025, *European Journal of Applied Physiology* (PMID 40402269) associates decoupling with the moderate-to-heavy transition and with durability; usable as an intra-session fatigue marker. Barsumyan et al. 2025, *Frontiers in AI* (PMID 40687435) applies ML on decoupling data.
- **Heat.** Périard and colleagues (heat-stress cycling literature): HR-based intensity thresholds keep relative stability between temperate and moderate heat, but exaggerated cardiac drift is a signal (not noise) of thermal strain. Consensus: HR rises 5-10 bpm per degree of core temperature above baseline.
- **Weighting when both HR and power are available.** Sanders et al. 2019 shows that intensity classification differs by metric; suggested weighting: **power for session prescription, HR for response/fatigue monitoring, sRPE for daily global load**. Consensus.

**Peer-review gap.** HR-only prescription specifically in amateur cyclists in tropical / Brazilian conditions is under-represented; extrapolating from elite / temperate data requires caution.

## 2. Motivational, psychological and routine factors

- **Self-Determination Theory (SDT).** Teixeira et al. 2012, *International Journal of Behavioral Nutrition and Physical Activity* (PMID 22726453): systematic review — **autonomous motivation** (identified, integrated, intrinsic) consistently predicts long-term exercise adherence; controlled motivation predicts initiation but not maintenance. Strong consensus.
- **Habit formation.** Lally et al. 2010 in *European Journal of Social Psychology* is the classical reference (widely cited even though the original DB indexing is uneven); Kaushal & Rhodes 2015 in *Journal of Behavioral Medicine* replicates and extends: **stable context and repetition in cue-consistent settings** (same time, same place) predicts habit strength more strongly than motivation. Consensus.
- **Overtraining / burnout — consensus statement.** Meeusen et al. 2013, *MSSE* joint ECSS/ACSM statement (PMID 23247672): defines OTS, distinguishes functional overreaching (FOR), non-functional overreaching (NFOR) and OTS; recommends multidimensional monitoring (physiological + psychometric + performance).
- **Recovery consensus.** Kellmann, Bertollo, Bosquet et al. 2018, *IJSPP* (PMID 29345524): RESTQ-Sport and other validated psychometric questionnaires; recovery is individual and multidimensional (physiological, psychological, social).
- **Psychosocial stress and recovery.** Stults-Kolehmainen & Bartholomew 2012, *MSSE* (PMID 22688829): life stress negatively moderates muscular recovery. Bartholomew et al. 2008, *Journal of Strength and Conditioning Research* (PMID 18545186): participants with lower life stress gained significantly more in squat/bench over 12 weeks. Consensus is emerging; endurance-specific evidence remains thinner than strength-specific.
- **Load and illness.** Schwellnus et al. 2016, *BJSM* IOC consensus (PMID 27535991): acute spikes in load combined with psychosocial stressors raise the risk of illness and injury. Consensus.
- **Mental toughness in endurance.** Zeiger & Zeiger 2018, *PLoS ONE* describes an 8-factor construct; Brace et al. 2020, *PLoS ONE* found **no correlation** between mental toughness and ultra performance. Active debate; the construct has known psychometric validity issues.

**Peer-review gap.** The effect of digital coaching / AI agents on adherence is a literature under construction; findings today extrapolate from generic mHealth without endurance-specific RCTs of high quality.

## 3. Noise variables (measurable but context-dependent)

- **Body weight — normal daily variability.** Bradshaw et al. 2024 (PMID 38634507): women show higher intra-individual variability; roughly 1-2% daily variation is normal noise (fluids, glycogen, gut). Consensus: use a rolling 7-day mean, not a single-day value.
- **Weight as a REDs signal.** Mountjoy et al. 2023 IOC REDs consensus statement: unintentional mass loss combined with low energy availability is a clinical signal; do NOT use daily weight in isolation as a trigger — integrate with HRV, mood, menstrual cycle.
- **Hydration.**
  - Sawka et al. 2007 ACSM Position Stand, *MSSE* (PMID 17277604): pre/post-session body mass change is the practical gold standard; >2% deficit impairs performance.
  - Cheuvront et al. 2015, *IJSNEM* (PMID 25386829): **spot urine specific gravity (USG) should not be used in isolation** for hydration status; test-retest fails in real-world conditions.
  - Kenefick & Cheuvront 2012, *Nutrition Reviews* (PMID 23121349): for recreational athletes, thirst + morning urine color is sufficient. Consensus: USG and body mass yes; individualized sweat rate is useful only if measured, not estimated.
- **Bike and equipment weight.**
  - Peterman et al. 2015, *PeerJ* (PMID 26290797): drag area dominates on flat terrain; weight matters on climbs (>~4%) and in repeated accelerations.
  - Voet et al. 2024, *Journal of Science and Medicine in Physical Fitness* (PMID 38888560): in pros, mountainous countries select lighter cyclists; anthropometric effect > equipment effect on climbs.
  - Bertucci et al. 2013, *Journal of Sports Sciences* (PMID 23713547): in MTB and flat road, rolling + drag dominate. Consensus: for amateurs, sub-100g on the bike matters little; aerodynamic position and tires save many more watts.
- **Environmental — altitude.** ~91 PubMed studies converge: VO2max drops ~1% per 100 m above 1500 m; submaximal HR increases on acute exposure and falls with acclimatization; power at a given HR drops. **Adjustment:** use HR + RPE, not absolute power, at altitude.
- **Environmental — heat.** HR rises, power falls; cardiac drift is normal, but magnitude is a signal.
- **Timing of measurements — morning HR / HRV.** Plews et al. 2013, *Sports Medicine* (PMID 23852425); Plews et al. 2014, *IJSPP* (PMID 24334285): the **rolling weekly mean of HRV** (ln rMSSD) beats daily values; requires ≥3-4 measurements/week to cut noise. Buchheit 2014, *Frontiers in Physiology* (PMID 24578692): submaximal HR recovery is a robust fitness/fatigue signal; resting HR in isolation is noisy. Consensus.

## 4. Variables to EXCLUDE from the model

- **Generic "how do you feel" self-report without a validated instrument.** Saw, Main & Gastin 2016, *BJSM* (PMID 26423706): systematic review shows validated subjective measures outperform objective ones — but that only holds for instruments such as Hooper wellness, POMS, RESTQ, DALDA. Free-text "how are you?" prompts do not reach acceptable test-retest reliability. Consensus: either use a validated short questionnaire or do not use.
- **Single-day resting HR.** Buchheit 2014 (PMID 24578692) and Bourdon et al. 2017 agree — resting HR in isolation has high day-to-day variability; use submaximal HR or weekly-mean HRV instead.
- **Single spot urine USG.** Cheuvront et al. 2015 (PMID 25386829): publicly criticized method; do not use as a standalone decision.
- **Proprietary metrics without independent validation.** Bourdon et al. 2017 explicitly recommend skepticism about closed composite scores that are not published in peer-reviewed journals with transparent methodology. Without naming platforms: any closed "readiness score" without a validation paper should be treated as noise.
- **Instantaneous pre-workout "I'm tired" perception without baseline.** Without longitudinal tracking, it does not distinguish real fatigue from a momentary state (coffee, one bad night). Kellmann et al. 2018 consensus: monitor trends, not points.
- **Theoretical HRmax (220 − age).** Errors of ±10-12 bpm; Karvonen with theoretical HRmax propagates the error. Prescribe using measured HRmax from an incremental test.
- **Isolated daily body weight as a trigger.** 1-2% variation is noise (Bradshaw et al. 2024). Use a 7-day rolling mean.
- **What Bourdon 2017 marks as low ROI in amateurs.** Extensive blood-biomarker panels, complex actigraphy, daily isometric strength tests — the recommendation is to focus on sRPE + short wellness + occasional submaximal HR.

## 5. Peer-reviewed methods used at the elite / World Tour level

- **Intensity distribution — polarized / pyramidal.**
  - Seiler & Kjerland 2006, *Scand J Med Sci Sports*: observational origin of the ~80/20 (Z1/Z3) pattern in elite XC skiing.
  - Foster, Casado, Esteve-Lanao, Haugen & Seiler 2022, *IJSPP*: argues polarized is optimal; the debate with pyramidal remains active.
  - Rosenblat et al. 2025 network meta-analysis: direct comparisons — polarized and pyramidal produce similar gains in VO2max / TT.
  - Active debate: polarized vs pyramidal depends on the point in the season and the athlete's level.
- **Case studies of elite / pro riders.**
  - Bell et al. 2017, *MSSE* (PMID 27508883): case study of a 2× TdF champion — physiological profile, body composition, submaximal cycling.
  - Barranco-Gil et al. 2024, *Journal of Applied Physiology* (PMID 38174376): comparison of recreational vs WorldTour riders over the 2023 TdF, 21 stages; reveals durability demands.
  - Valenzuela et al. 2022, *IJSPP* (PMID 36521188): durability in pros — 20-min TT fresh vs fatigued.
  - Muriel et al. 2021, *IJSPP* (PMID 32820136): impact of COVID lockdown on pros; shows a fast drop in fitness without structured stimulus.
- **van Erp series.** A body of *IJSPP* papers (2019-2025) describes "record power profile", stage-type demands, sex-based differences and field-derived durability.
- **Monitoring at elite level.**
  - Plews et al. 2013, 2014, 2017, *Sports Medicine* and *IJSPP*: weekly HRV (ln rMSSD) in world-champion rowers; method — morning collection 4-5× / week, plot the trend.
  - Buchheit 2014, *Frontiers in Physiology*: submaximal HR (60-s recovery after a standard test) as an elite fitness/fatigue marker.
  - Halson 2014, *Sports Medicine*: recovery monitoring in elite athletes with multidimensional integration.
- **Durability / physiological resilience.** Jones 2024, *Journal of Physiology* (PMID 37606604): durability as an independent determinant; suggests that fresh tests underestimate true elite capacity.
- **Responder / non-responder.**
  - Emerging consensus: "non-responders" respond given a larger dose; HRV-guided training reduces non-responder rates.
  - Ross et al. and others (~33 PubMed studies): genetic heterogeneity and individual trainability; individualization is the norm at elite level.
- **Load cycles.** Rønnestad et al. 2020, *Scand J Med Sci Sports* (PMID 31977120): in elite athletes, short intervals (30/15) outperform effort-matched long intervals; foundation for HIIT blocks in pros.

**Not found in peer review.** Specific prescriptions from commercial platforms. That is acceptable — the question is **methodological**, and peer-reviewed methodology describes: (1) power-based prescription individualized via measured CP / FTP / threshold, (2) monitoring with weekly HRV + sRPE + short wellness, (3) periodization with contrasting intensity blocks, (4) durability tested in the field, (5) individualized response.

## Sub-topics where peer review is thin or absent

- **HR-based training in Brazilian / tropical amateurs.** Almost absent; extrapolation from temperate data with caution.
- **Habits + cycling amateur adherence.** The habit literature is strong in general PA but scarce in cycling specifically.
- **Effect of "AI coach" on adherence.** Under construction; no high-quality endurance-specific RCTs yet.
- **Effect of bike weight in amateurs training on rollers / flat.** The effect is near zero, but there is no direct RCT — inference from physics + pro-in-mountain studies.
- **Independent validation of proprietary metrics.** Almost none; most commercial scores lack independent papers.

---

**Excluded by quality:** any result that would arrive via WebSearch on coaching blogs, platform marketing, YouTube opinions or non-scientific magazines. None were used. arXiv was not consulted. Theses were not used except where cited by the peer-reviewed journals above.
