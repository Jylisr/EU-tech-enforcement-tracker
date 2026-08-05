# Coding Rules

This document is the single source of truth for how each variable in
`data/enforcement_data.csv` is coded. Update it the moment you make a new
judgment call — do not let the rule live only in your head. This file
becomes Section 3.2 of the paper almost verbatim.

## Unit of analysis

One enforcement decision by one national supervisory authority (DPA) or
court against one entity, involving at least one GDPR violation, resulting
in a documented outcome, occurring in an EU Member State between 2018 and
the present.

## Member States covered

**Scope expanded (schema v2) from the original five-state pilot to all EU
Member States**, because GDPRhub simply does not have enough coded cases
in five states alone to reach a workable sample size. States with at
least one coded decision so far: Ireland, Germany, France, Finland,
Estonia, Netherlands, Spain, Lithuania, Greece, Italy, Poland, Hungary.

**The United Kingdom is deliberately excluded, and this is not just "not
yet expanded to."** Post-Brexit, the UK applies its own UK GDPR — a
distinct legal regime, no longer subject to the EU GDPR, CJEU
jurisdiction, or the harmonisation objective this project investigates. A
UK case doesn't measure divergence *within* the EU framework; it measures
something else. If UK cases are wanted for comparison, they belong in a
clearly separated section of the analysis, not blended into the main
sample.

## Schema v2 changes (see coding_log.md for the full record)

- Added `ecli` column — European Case Law Identifier where the decision
  has one. Coverage is uneven: CJEU decisions always have one; national
  courts increasingly do; lower-instance DPA decisions frequently don't.
  Leave blank (not "n/a") when absent, for easier filtering.
- Added `fine_amount` column — separate from `damages_awarded`.
  `damages_awarded` is Article 82 compensation paid *to the data subject*
  who brought the claim. `fine_amount` is an Article 83 administrative
  fine paid *to the state* by the controller. These are different legal
  mechanisms with different purposes and should never be combined into
  one column or compared as if they were the same kind of number.
- Added `not_yet_decided` as a valid `harm_type` value, distinct from
  `none_found`. `none_found` means a court or DPA actively considered the
  harm question and found none. `not_yet_decided` means the case is a
  procedural ruling — jurisdiction, applicable law, authorisation
  requirements — and the harm/damages question hasn't been reached yet.
  Conflating these was flagged as a problem with EU-012 in the original
  pilot; this release fixes it retroactively.
- `enforcing_body` is being used as a coarse category: `court_appeal`
  covers ordinary appellate courts *and* supreme/cassation courts alike,
  since the schema doesn't distinguish them separately. If that
  distinction becomes analytically important later, split it then rather
  than guessing now.
- Two sector gaps identified this batch with no clean fit in the existing
  taxonomy: telecoms (SIM/mobile carriers) and hospitality (hotels). Both
  currently coded `other`. Worth adding dedicated categories if more
  telecom or hospitality cases turn up.

## Variable definitions

| Variable | What it records | How to code it |
|---|---|---|
| `case_id` | Unique identifier | Sequential: EU-001, EU-002 … Assign in coding order, not date order. |
| `member_state` | Country of the enforcing authority | Two-letter ISO code (e.g. IE, DE, FR, FI, EE, NL, ES, LT, EL, IT, PL, HU). Use the authority's home state, not where the company is incorporated. |
| `authority` | Specific DPA or court | Full, consistent name (e.g. "Data Protection Commission (Ireland)"). Always use the exact same string for the same authority. If a source's own categorisation (e.g. GDPRhub's "Authority" field) conflicts with what the decision text itself says issued the ruling, use what the decision says and flag the discrepancy in the coding log — see EU-020 for an example. |
| `ecli` | European Case Law Identifier | Exact ECLI string where the decision has one (e.g. `ECLI:DE:OLGDRES:2024:1210.4U808.24.00`). Leave blank if none — do not write "n/a", to keep the column simple to filter. |
| `year` | Year decision was issued | Four-digit year of publication, not complaint date. If a source's stated date conflicts with what its own ECLI encodes, trust the ECLI and flag the discrepancy — see EU-026. |
| `sector` | Digital sector of the entity | One of: `social_media`, `adtech`, `cloud_services`, `ecommerce`, `financial_services`, `health_tech`, `other`. |
| `legal_basis` | GDPR article(s) forming the basis of the finding | Primary article first (e.g. Art. 5, Art. 6, Art. 9, Art. 13, Art. 17, Art. 82). Multiple articles separated by semicolons. **Only include actual GDPR articles here.** Some enforcement is based on a national statute that merely echoes a GDPR article number (e.g. France's LIL Article 82, an ePrivacy transposition, is not GDPR Article 82) — including that string here would falsely match the `str_detect("Art\\. 82")` filter used throughout the analysis script. Note the national-law basis in the coding log instead — see EU-017. |
| `violation_type` | What the controller did wrong | One of: `unlawful_processing`, `transparency_failure`, `data_subject_rights`, `security_breach`, `transfer_violation`, `other`. |
| `enforcing_body` | Who issued the decision | One of: `DPA`, `court_first_instance`, `court_appeal`, `EDPB`. `court_appeal` covers ordinary appellate courts and supreme/cassation courts alike (schema v2 simplification — see above). |
| `damages_awarded` | Article 82 compensation awarded to the data subject (EUR) | Number only, no currency symbol. `NA` if no damages awarded, no Art. 82 claim was involved, or the case is an administrative fine (use `fine_amount` for that instead). |
| `fine_amount` | Article 83 administrative fine paid to the state (EUR) | Number only. `NA` if no fine was imposed or the case is a private damages claim. Never combine with `damages_awarded` — they measure different things. |
| `harm_type` | Type of harm suffered | One of: `non_material`, `material`, `reputational`, `multiple`, `none_found`, `not_yet_decided`. See rules below. |
| `cross_border` | Cross-border processing / OSS cooperation | `TRUE` / `FALSE`. See rules below. |

## harm_type rules

- **non_material** — decision explicitly describes distress, anxiety, loss
  of control over personal data, fear of identity theft, or similar
  non-pecuniary harm, without a specific financial loss identified.
- **material** — a specific quantifiable financial loss is identified
  (lost income, fraudulent transactions, costs incurred).
- **reputational** — decision specifically references harm to the data
  subject's reputation, standing, or professional position.
- **multiple** — decision identifies more than one category of harm and
  treats them as distinct.
- **none_found** — decision explicitly states no harm was proven, or the
  case is a regulatory fine rather than an Art. 82 damages claim.
- **not_yet_decided** — the decision is procedural only (jurisdiction,
  applicable law, authorisation requirements) and does not reach the
  harm/damages question at all. Do not code this as `none_found` — that
  implies the harm question was considered and rejected, which is a
  different and stronger claim than "not yet reached."

**Default rule:** if the decision doesn't specify a harm type but awards
damages, code as `non_material`. Per *Österreichische Post* (C-300/21), the
CJEU held non-material harm includes mere loss of control over personal
data even without proven distress.

## cross_border rules

- `TRUE` if the controller's EU main establishment is in a different
  Member State from the complainant.
- `TRUE` if the decision explicitly mentions Article 60 GDPR cooperation.
- `TRUE` if the decision follows an EDPB Article 65 binding decision.
- `FALSE` if controller and complainant are in the same Member State and
  no cross-border mechanism was invoked.
- `FALSE` if you cannot determine cross-border status from the decision —
  when in doubt, code `FALSE` and note the uncertainty in the coding log.

## sector rules

- **adtech** — primary business involves targeted advertising, data
  brokerage, or ad-tech platforms, even if the company also runs a social
  network.
- **social_media** — platforms whose primary function is user-generated
  content sharing and social networking.
- **ecommerce** — primary business is online retail (note overlap with
  adtech; code the *primary* business).
- If a company spans multiple sectors, code the sector most relevant to
  the specific violation being enforced.

## Translation note

For non-English decisions, use DeepL rather than Google Translate — it
handles EU legal terminology more accurately. Note in the coding log
whenever translation was used, and flag any nuance that may have been lost.
