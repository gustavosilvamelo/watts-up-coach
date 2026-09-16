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

## 2. (reserved for future premises)
