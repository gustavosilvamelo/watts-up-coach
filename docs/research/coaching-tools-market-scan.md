# Coaching Tools Market Scan — Research Reference

Market survey of existing cycling coaching platforms (and one running reference), gathered during system design. Focus: what these tools consume, what they output, how they adapt, whether they use AI/ML, pricing, target audience, and known criticisms. Ends with convergences, divergences, gaps for amateurs, and opportunities.

Captured: 2026-09-16.

## Methodology note

Research was conducted via **WebFetch** on official sites and some third-party review pages. **WebSearch was blocked** in the environment, and **Reddit and DC Rainmaker returned fetch blocks**. This scan is therefore based on:

- Official platform sites (self-marketing — declarative, not independent).
- Support/help pages where accessible.
- A few third-party review pages that responded (most returned 404).

Where independent verification was not possible, sections are marked as "self-marketing, not confirmed by independent review".

---

## 1. TrainingPeaks (Premium + Coaching)

**Source:** https://www.trainingpeaks.com/pricing/

- **Data:** FTP, HR, TSS, PMC (CTL/ATL/TSB), workouts synced from Garmin/Wahoo/Zwift. Wellness/HRV via external integration (not core). No mention of active HRV use for adaptation.
- **Output:** Planned calendar (drag-and-drop), structured workouts, PMC/analytics. No native daily adaptive prescription. **Adaptation comes from the human coach**, not the system.
- **Adaptation to feedback:** Post-workout RPE exists as a field, but it feeds the coach — there is no autonomous engine that re-plans.
- **AI/ML:** Absent from the official page. TrainingPeaks is a data + calendar platform, not an algorithmic coach.
- **Pricing:** Premium $19.95/month or $134.99/year. Coach (Bronze/Silver/Gold) $149-359/month. **No functional free tier.**
- **Audience:** All levels, but dominant among professional coaches and experienced athletes who can interpret PMC.
- **Known criticism** (based on general product knowledge — not verified in this session): steep learning curve; without a human coach it becomes an expensive data store; PMC is not intuitive for amateurs.

---

## 2. Xert

**Sources:** https://baronbiosys.com/ + https://baronbiosys.com/xert/

- **Data:** Power (required for the core). Derives a **3-parameter Fitness Signature** (Threshold Power, High Intensity Energy, Peak Power) — replaces a single FTP number. Detects "breakthrough events" automatically without a formal FTP test.
- **Output:** **Daily adaptive prescription** via XATA (Xert Adaptive Training Advisor). Recommends what to do today based on current status, not a fixed weekly plan.
- **Adaptation to feedback:** Power-meter-based (analyzes each ride, adjusts MPA — Maximum Power Available). Xert Strain Score categorizes effort into low/high/peak.
- **AI/ML:** "Forecast AI" is mentioned for plan prediction adjusting to life changes. The core engine is a physical-mathematical model (MPA), not classical ML — despite the "AI" rebranding.
- **Pricing:** Free Starter (limited); Premium $14.99/month or $99.95/year.
- **Audience:** Technical/data-nerd cyclists with power meters. Not beginner-friendly.
- **Known criticism:** UI/UX considered complex; steep learning curve; heavy technical documentation. (General perception, not verified in this session.)

---

## 3. Intervals.icu

**Source:** https://intervals.icu/

- **Data:** Syncs 250+ apps (Strava, Garmin, Wahoo, Zwift, Polar, Coros, Oura, WHOOP). Consumes everything: power, HR, HRV (via Oura/WHOOP), wellness.
- **Output:** Deep analytics (fitness/fatigue/form, power curve, automatic interval detection), calendar, workout builder. **Does not prescribe workouts** — it is an analytics + manual-planning tool.
- **Adaptation to feedback:** None automatic. Athlete/coach do it manually.
- **AI/ML:** Not core. Some AI-assisted feature in the forum, but not the engine.
- **Pricing:** **Free permanently**, no credit card. "Supporter" $4/month unlocks annual builder and bulk config. Best price/value on the market.
- **Audience:** 160,000+ active athletes. Very popular among independent coaches, DIY users, and cyclists who left TrainingPeaks for cost reasons.
- **Known criticism:** Does not prescribe — requires the user to know what to do. Excellent tool, poor "coach".

---

## 4. TrainerRoad (Adaptive Training)

**Sources:** https://www.trainerroad.com/adaptive-training/ + https://www.trainerroad.com/pricing/

- **Data:** FTP (via AI FTP Detection, no formal test required), workout completion, RPE via post-workout survey, external activities (Strava/Garmin/Zwift), life events (illness, vacations, added races).
- **Output:** Structured plan + prescribed daily workouts. **TrainNow** offers on-demand workouts when the plan breaks.
- **Adaptation to feedback:** Strong point. Post-workout survey (easy/moderate/hard/very hard/impossible) feeds the model. Missed workouts, crushed workouts, external activities → auto re-plan. Also detects fatigue.
- **AI/ML:** Yes, explicitly stated. "TrainerRoad AI" runs "hundreds of simulations". "AI FTP Detection" and "Fatigue Detection". Closest to real declared ML among competitors.
- **Pricing:** $17.45/month (annual $209.99) or $21.99/month. **No free tier**, but 30-day money-back.
- **Audience:** Cyclists of all levels, but marketing and philosophy (hard workouts, "get faster") appeals more to the serious/racer amateur.
- **Known criticism:** Marketing leans heavily on "AI" — in practice the adaptive engine is statistical rules + progression levels + surveys, not deep learning. Limited variety outside indoor trainer. Indoor-first UX.

---

## 5. Humango

**Source:** https://humango.ai/

- **Data:** User goals, weekly availability, wearables, performance/adherence, recovery/fatigue metrics.
- **Output:** Hyper-personalized plan that "evolves continuously". Visual dashboard, session previews.
- **Adaptation:** Based on availability, wearable data, adherence, fatigue, progress. "Hugo" (AI coach) gives real-time feedback and flags inconsistencies in effort.
- **AI/ML:** Declares an AI coach ("Hugo"). No technical detail on architecture. Self-marketing, no independent review.
- **Pricing:** Not disclosed publicly on the home page — free trial offered. Lack of transparency.
- **Audience:** Individual athletes (endurance, triathlon, cycling, running), coaches, teams. Marketing emphasizes "busy life".
- **Known criticism:** Very new/little known in the market; lack of mature independent reviews.

---

## 6. Athletica.ai

**Sources:** https://athletica.ai/ + https://athletica.ai/pricing

- **Data:** Training history, performance, recovery, integration with Garmin/Strava/Coros/Wahoo/Concept2, self-reported fatigue, schedule constraints.
- **Output:** Sessions via iOS/Android app. Personalized zones via a simple baseline test.
- **Adaptation:** Recalculates "intelligently, not aggressively" for missed workouts, travel, bad sleep. **Key point:** AI **suggests but does not modify automatically** — "You're always in control".
- **AI/ML:** "AI Coach" trained on a knowledge base curated by physiologists and endurance coaches. Explicitly differentiates itself from "generic chatbot". Likely RAG over a scientific corpus (not technically confirmed).
- **Pricing:** 2-week free trial. Monthly $19.90, 6 months $99, annual $189. No paid tiers (feature parity).
- **Audience:** Beginner to elite. Multi-sport (tri, running, cycling, duathlon, HYROX, rowing, XC skiing).
- **Known criticism:** Founded by Paul Laursen (respected physiologist) — high scientific credibility, but the product is still relatively new.

---

## 7. JOIN Cycling

**Sources:** https://join.cc/ + https://join.cc/pricing

- **Data:** Calendar/availability, Strava integration, workout completion, target event. HRV/wellness **not explicitly mentioned**.
- **Output:** Dynamic adaptive plan. 400+ workouts based on HR and/or power. Indoor player with performance grading. FTP detection.
- **Adaptation:** Workout shuffle based on availability and unplanned activities (e.g., club rides). "Learns as you ride."
- **AI/ML:** "AI-powered" marketing, "coach in your pocket". No technical detail. Self-marketing.
- **Pricing:** €16.99/month or €119.99/year (€9.99/month). 7-day trial. Feature parity.
- **Audience:** All levels, but marketing emphasizes accessibility and "busy life" — clear amateur target.
- **Declared metrics:** +19.8% FTP in 12 months, 82.4% of users hit their goal. **Self-marketing numbers, not audited.**
- **Known criticism:** Less deep analysis than TrainerRoad; less "serious" perception among racers.

---

## 8. Runna (running, similar principles)

**Source:** https://runna.com/pricing

- **Data:** Level, recent race time, availability, goal, sync with Apple Watch/Garmin/Fitbit/Coros/Suunto.
- **Output:** 6-26 week plans, 5K to 50K. Adaptive workouts.
- **Adaptation:** Based on wearable and workout completion. Real-time adjustments not explicitly detailed.
- **AI/ML:** "Runna Engine" does algorithmic personalization. Marketing.
- **Pricing:** $19.99/month or $119.99/year. 7-day trial.
- **Audience:** All runner levels.
- **Ratings:** 4.9/5 on Apple (76k+), 4.7/5 on Google Play (17k+) — high adoption.
- **Lesson for cycling:** Simplified UX + wearable-based adaptation + goal-race-specific plans is a formula that resonates with amateurs. Runna is a UX reference for the segment.

---

## 9. AI Endurance

**Sources:** https://aiendurance.com/ + https://aiendurance.com/pricing/

- **Data:** 12+ integrations (Garmin, Suunto, Coros, Polar, Wahoo, Hammerhead, Intervals.icu, Strava, Stryd, Oura, WHOOP, Zwift). Pushes workouts to Garmin, Suunto, Coros, Wahoo, TrainingPeaks, etc.
- **Output:** "Digital Twin" — neural network that learns individual response to training. Re-optimizes after each workout.
- **Adaptation:** Continuous. Race performance prediction.
- **AI/ML:** **Explicitly declares a per-athlete neural network ("Digital Twin")** — the strongest technical claim in the group. Not independently audited.
- **Pricing:** 14-day trial, no card. Monthly/annual with no exact values on the page.
- **Audience:** Endurance athletes — cyclists, runners, triathletes.
- **Known criticism:** Small, niche, little known; "digital twin" claims need more independent evidence.

---

## 10. Wahoo SYSTM (formerly Sufferfest)

**Source:** https://www.wahoofitness.com/systm

- **Data:** Power + result of the Full Frontal test (4DP profile: NM/AC/MAP/FTP for cycling; 3DP for running).
- **Output:** Guided videos (motion-picture-quality) + periodized plans. Categorizes the athlete into a type (Sprinter/Attacker/Pursuiter/TT/Climber/Rouleur) and adjusts workouts.
- **Adaptation:** Plan Builder adjusts for event/available time. "Reads your training and points you to the right workout" — but less aggressive/algorithmic than TR.
- **AI/ML:** Less emphasis on AI. Focus is 4DP (personalization by power profile) + video content quality.
- **Pricing:** Free base, Core $4.99/month, Pro $17.99/month (full SYSTM).
- **Audience:** Cyclists who value an engaging indoor experience (videos, cinematography, gamification). Motivated amateur.
- **Known criticism:** After the Wahoo acquisition, lost part of the original Sufferfest community; less "serious" than TR for racers; strong indoor, weak outdoor prescription.

---

## SYNTHESIS

### Convergences (what everyone does — copy without reinventing)

1. **FTP-centric.** Everyone consumes power or HR. FTP (or a variant like Xert's 3-param, SYSTM's 4DP) is ubiquitous. Without a power meter, the product is HR-only and limited.
2. **Sync with dominant platforms.** Strava, Garmin, Wahoo, Zwift, Coros are baseline. Without them, no one adopts.
3. **Adaptive re-planning for missed workouts** — TR, Xert, JOIN, Humango, Athletica, AI Endurance. Table-stakes in 2026.
4. **Calendar + workout builder + PMC-like view.** Universal.
5. **"AI" in marketing.** Everyone uses it. Only TR and AI Endurance have concrete technical claims. Xert is a physical model called AI. Athletica is RAG + suggestion. JOIN/Humango/Runna are black boxes.

### Divergences (where there is disagreement)

- **Top-down (periodized weekly plan) vs. bottom-up (daily prescription).** TR and SYSTM are top-down. **Xert is the most bottom-up pure** (daily, no fixed plan). JOIN/Humango are hybrids.
- **AI decides vs. AI suggests.** **Athletica is explicit: it suggests, does not modify** (respecting autonomy). TR modifies autonomously. Xert too.
- **Feature parity vs. tiered.** JOIN and Athletica chose no tiers (user-friendly). TR and TrainingPeaks are tiered. Intervals.icu is radical freemium.
- **Human coach in the loop.** TrainingPeaks bets on a human as a differentiator. Everyone else tries to replace them.
- **Wellness/HRV integration.** Athletica, Humango, AI Endurance (via Oura/WHOOP) integrate. **TR and Xert do not use HRV as an adaptation signal in a central way** — the biggest technical gap.

### Gaps for amateurs (recurring complaints and overengineering)

Based on what the products claim vs. what an amateur typically needs:

1. **Setup complexity.** Xert and TrainingPeaks require understanding PMC, TSS, MPA. Amateurs give up. Runna solves this via simple UX — nobody in cycling replicates that level of simplicity.
2. **"Why this workout?"** No platform explains the reasoning pedagogically. They prescribe but do not teach. Athletica is closest (AI coach explains), but still partial.
3. **Weak contextualization.** Missed workouts are understood, but amateur cycling has context (rain, sick child, unexpected ride with friends, regional race added late) that current systems handle in a binary way.
4. **HRV/sleep not used as a central signal.** Athletica and AI Endurance are starting to integrate; no one does it pedagogically.
5. **Poor qualitative feedback.** RPE 1-5 is the maximum. No one accepts free text ("today was bad because I fought at work, couldn't focus"). An LLM agent naturally solves this.
6. **Similar-group / social learning.** No one uses data from similar athletes (age/weight/level/history) to calibrate prescription. Everyone treats the athlete as an island.
7. **Regional race / local calendar.** A Brazilian amateur has regional races not known globally. No platform knows about "Desafio Serra da Cantareira" — the user has to create a generic event.

### Opportunities for an Agentic RAG agent (Claude + own data + literature + similar groups)

Prioritized by real differentiation:

1. **Conversation as primary feedback interface.** Replace binary RPE with a short post-workout dialogue. "How was it?" with Claude understanding "I got more tired than usual, my left leg felt heavy" — inferring localized fatigue, prioritizing recovery or a change of focus. **No competitor does this.**
2. **Pedagogical explainability.** Every prescription comes with "why this workout, now, for you" citing literature (RAG over a physiology corpus — Coggan, Allen, Laursen, Seiler). Athletica scratches the surface; a RAG agent does this natively.
3. **Integrated life context.** Google Calendar, local weather, sleep history (Oura/Whoop), even work emails ("you have 3 back-to-back meetings early tomorrow, I moved the intense workout to the day after"). No competitor crosses these signals.
4. **Similar group / social RAG.** "Amateur cyclists aged 35-45, 8-10h/week, with FTP between 240-280W typically respond to this block with an X% gain." Requires a data cohort — high barrier, but defensible long term.
5. **Local race, not global.** Ingest of regional calendars (FPC, CBC, state calendars) + plan adaptation.
6. **Bottom-up prescription + top-down explanation.** Like Xert (daily), but with a "where we are going" narrative that Xert does not deliver well. Amateurs need visible narrative progress, not only the next workout.
7. **Multi-modal feedback.** Voice during the workout ("this is way too hard now, can I reduce?"), route photos, data from external sensors (glucose monitors, if relevant).
8. **Cost.** If Agentic RAG fits in $9-12/month, it competes directly with JOIN and Xert. Intervals.icu is unbeatable on cost but does not prescribe — not a direct competitor.

### Known threats to positioning

- **TR already dominates "adaptive" in the amateur racer's perception.** Differentiate as "for the amateur who wants to understand, not just execute".
- **Athletica.ai is the closest conceptual competitor** (RAG over science + explanation). Competitive advantage comes from: better UX, real conversational feedback, life integration, and/or cost.
- **Data barrier.** Rapidly acquiring users is essential to calibrate the social/cohort RAG.

---

## Verifiable sources consulted

- https://www.trainingpeaks.com/pricing/
- https://intervals.icu/
- https://www.trainerroad.com/adaptive-training/
- https://www.trainerroad.com/pricing/
- https://humango.ai/
- https://athletica.ai/
- https://athletica.ai/pricing
- https://join.cc/
- https://join.cc/pricing
- https://runna.com/pricing
- https://aiendurance.com/
- https://aiendurance.com/pricing/
- https://www.wahoofitness.com/systm
- https://baronbiosys.com/ (Xert)
- https://baronbiosys.com/xert/ (Xert overview)

## Attempted and blocked / unavailable sources

- WebSearch (denied in the environment).
- Reddit (r/Velo, r/cycling) — blocked.
- DC Rainmaker — 404s on the URLs tried.
- Velo/Outside Online — blocked by auth.
- BikeRadar, CyclingNews, CyclingWeekly, ZwiftInsider — 404s or timeout.
- Xert /pricing, /plans, /products — 404s. Xert help wiki — ECONNREFUSED.
- TrainerRoad help/support pages — 403.
- Wahoo SYSTM blog specific pages — 404s.

**Consequence:** the "known criticism" sections above are marked as general domain knowledge, not verified in this session. If verifiable citations for these criticisms are needed, either unblock WebSearch or supply specific post/video URLs to fetch.
