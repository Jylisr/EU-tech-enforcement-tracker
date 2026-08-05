# Sources

Every row in `enforcement_data.csv` must trace back to a citable original
decision or an official regulator publication. This file is that trace.
Add an entry here *before* adding the row to the CSV — not after.

| case_id | Case / decision | Citation | Primary source |
|---|---|---|---|
| EU-001 | *Kaminski v Ballymaguire Foods Ltd* | [2023] IECC 5, Circuit Court, 11 July 2023 | [courts.ie judgment](https://www.courts.ie/view/Judgments/b29c0f8b-f732-47cf-85ef-37566b36f88c/60c1e7c8-a82b-4447-a919-111d788d2d12/2023_IECC_5.pdf/pdf) · [GDPRhub summary](https://gdprhub.eu/index.php?title=Circuit_Court_-_2019/04546) |
| EU-002 | *M.H. v Child and Family Agency* | Circuit Court, ex tempore judgment, 2023 | [William Fry summary](https://www.williamfry.com/knowledge/highest-gdpr-award-for-damages-in-irish-court/) — no written judgment published; verify via Courts Service if a citation issues |
| EU-003 | Facebook 2019 breach claim | LG Köln, 28 O 138/22 | [GDPRhub summary](https://gdprhub.eu/index.php?title=LG_K%C3%B6ln_-_28_O_138/22) |
| EU-004 | Scalable Capital data breach | LG Köln, 28 O 328/21, 18 May 2022 | [GDPRhub summary](https://gdprhub.eu/index.php?title=LG_K%C3%B6ln_-_28_O_328/21) |
| EU-005 | Loyalty-programme data shared with social network for ad targeting (company not named by CNIL) | CNIL Délibération SAN-2025-017, 30 December 2025 | [CNIL press release](https://www.cnil.fr/fr/transmission-de-donnees-un-reseau-social-des-fins-publicitaires-sanction) · [Légifrance text](https://www.legifrance.gouv.fr/cnil/id/CNILTEXT000053391342) |
| EU-006 | Posti Oy — change-of-address transparency failure | Finnish DPO decision, 18 May 2020 | [Dittmar & Indrenius summary](https://www.dittmar.fi/news/first-finnish-gdpr-fines-set-a-new-tone-for-data-protection-supervision/) |
| EU-007 | Debt collection agency — access request failures | Finnish DPO Sanctions Board decision, 2023 | [Waselius summary](https://www.waselius.fi/news/2023/01/stepping-into-2023-with-significant-gdpr-rulings-from-the-finnish-dpa-and-the-ecj/) |
| EU-008 | Health/fitness data company — invalid consent for health data | Finnish DPO Sanctions Board decision, 11 January 2023 | [tietosuoja.fi press release](https://tietosuoja.fi/en/-/administrative-fine-imposed-on-company-for-processing-health-information-without-the-appropriate-consent) |
| EU-009 | Allium UPI OÜ (Apotheka loyalty scheme) data breach | AKI decision, 5 September 2025 | [Captain Compliance summary](https://captaincompliance.com/education/the-cost-of-complacency-estonias-e3-million-wake-up-call-on-data-breaches/) — verify against AKI's own published decision before finalising |
| EU-010 | Neighbour CCTV surveillance, no valid legal basis | AKI decision 2.1.-1/22/1396 | [GDPRhub summary](https://gdprhub.eu/index.php?title=AKI_%28Estonia%29_-_2.1.-1%2F22%2F1396) |

## Verification status

These ten rows were seeded from secondary summaries (GDPRhub, law-firm
client alerts, regulator press releases) found via web search, cross-checked
against at least one other independent source where possible. **Per Step 3
of the guide, this is not a substitute for reading the original decision.**
Before relying on any of these for the paper:

- [ ] EU-001 — read full judgment (PDF linked above), confirm legal_basis and violation_type
- [ ] EU-002 — no written judgment appears to be published; confirm citation/neutral citation number before citing in the paper, or treat as a secondary-source-only case and flag this in Section 3.3 (Limitations)
- [ ] EU-003 — read via GDPRhub, confirm cross-border reasoning (Meta/Facebook establishment)
- [ ] EU-004 — confirm exact decision date and damages figure against LG Köln original
- [ ] EU-005 — confirm sector coding (loyalty programme retailer) — CNIL did not name the company, which limits what can be said about it in the paper
- [ ] EU-006 — confirm this is not superseded by the later Supreme Administrative Court ruling on the same case
- [ ] EU-007 — find the actual decision reference number (not just the press summary)
- [ ] EU-008 — confirm cross_border coding (explicitly a one-stop-shop case) and company sector
- [ ] EU-009 — this is Estonia's largest-ever data protection decision; get the AKI decision number directly from aki.ee rather than relying solely on secondary coverage
- [ ] EU-010 — confirm exact decision year (case number suggests 2022; article coverage is from mid-2023)
