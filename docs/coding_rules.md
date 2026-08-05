# Coding Rules

This document is the single source of truth for how each variable in
`data/enforcement_data.csv` is coded. Update it the moment you make a new
judgment call — do not let the rule live only in your head. This file
becomes Section 3.2 of the paper almost verbatim.

## Unit of analysis

One enforcement decision by one national supervisory authority (DPA) or
court against one entity, involving at least one GDPR violation, resulting
in a documented outcome, occurring in one of the five Member States below
between 2018 and the present.

## Member States covered

- Ireland (DPC)
- Germany (state DPAs / DSK)
- France (CNIL)
- Finland (Tietosuojavaltuutetun toimisto)
- Estonia (AKI)

## Variable definitions

| Variable | What it records | How to code it |
|---|---|---|
| `case_id` | Unique identifier | Sequential: EU-001, EU-002 … Assign in coding order, not date order. |
| `member_state` | Country of the enforcing authority | Two-letter ISO code: IE, DE, FR, FI, EE. Use the authority's home state, not where the company is incorporated. |
| `authority` | Specific DPA or court | Full, consistent name (e.g. "Data Protection Commission (Ireland)"). Always use the exact same string for the same authority. |
| `year` | Year decision was issued | Four-digit year of publication, not complaint date. |
| `sector` | Digital sector of the entity | One of: `social_media`, `adtech`, `cloud_services`, `ecommerce`, `financial_services`, `health_tech`, `other`. |
| `legal_basis` | GDPR article(s) forming the basis of the finding | Primary article first (e.g. Art. 5, Art. 6, Art. 9, Art. 13, Art. 17, Art. 82). Multiple articles separated by semicolons. |
| `violation_type` | What the controller did wrong | One of: `unlawful_processing`, `transparency_failure`, `data_subject_rights`, `security_breach`, `transfer_violation`, `other`. |
| `enforcing_body` | Who issued the decision | One of: `DPA`, `court_first_instance`, `court_appeal`, `EDPB`. |
| `damages_awarded` | Monetary amount awarded (EUR) | Number only, no currency symbol. `NA` if no damages awarded or no Art. 82 claim was involved. |
| `harm_type` | Type of harm suffered | One of: `non_material`, `material`, `reputational`, `multiple`, `none_found`. See rules below. |
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
