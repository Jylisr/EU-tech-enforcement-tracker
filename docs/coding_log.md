# Coding Log

Record every judgment call here as you code, in order. Do not batch this
up after the fact — reconstructing a decision days later is much harder
than writing two sentences in the moment. This log becomes Section 3.2 of
the paper.

Format for each entry:

1. **Case ID**
2. **The question you faced**
3. **The decision you made and why**
4. **The rule you applied or created** (add new rules to `coding_rules.md`
   immediately)

---

### Example entry (delete once you have real entries)

**EU-007** — The decision mentions the data subject experienced distress
but does not quantify it, and no financial loss is described. Coded
`harm_type` as `non_material` per the default rule. New rule created:
unquantified distress without financial loss = `non_material`.

---

<!-- Add your entries below, most recent last -->

**EU-001 (Kaminski v Ballymaguire Foods)** — Sector question: the case involves an employer (a food manufacturer) and CCTV footage of an employee, not a "digital sector" company in the usual sense. None of the listed sectors fit; coded as `other`. New rule: employer/workplace-data cases involving a non-digital-sector employer are coded `other`.

**EU-002 (M.H. v Child and Family Agency)** — Same sector issue: a public-sector child-and-family agency, not a digital-sector business. Coded `other`. Also: I could not find a published written judgment, only law-firm secondary reporting of an ex tempore ruling. Flagged in `docs/sources.md` as needing verification — this may need to be excluded or treated as a footnote-only case rather than a fully-coded row if no citable judgment surfaces.

**EU-003 (LG Köln 28 O 138/22)** — Claim was for €1,000 but the court rejected it entirely. Coded `damages_awarded` as NA (per the rule: NA covers "no damages awarded", not just "no claim made") and `harm_type` as `none_found` since the court explicitly found no compensable damage. cross_border coded TRUE: the underlying 2019 Facebook breach affected 533 million people across 106 countries and the controller (Meta) has its EU main establishment in Ireland, while the claim was heard in Germany — this is the textbook cross-border fact pattern even though no Art. 60/65 mechanism is mentioned in the summary. New rule: cross_border can be coded TRUE based on the controller's known main establishment even absent an explicit OSS/Art. 60 reference in the decision, provided the mismatch between establishment and forum is independently verifiable.

**EU-005 (CNIL SAN-2025-017)** — CNIL chose not to name the sanctioned company. Sector coded as `ecommerce` based on the description of "articles sold by the company" and a loyalty programme, but this is a lower-confidence call than named-company cases — noted in `docs/sources.md`. cross_border coded TRUE per the explicit statement that 16 EU counterpart authorities cooperated on this decision (Art. 60 pattern).

**EU-008 (Finnish health-data company)** — cross_border coded TRUE: decision states the company's service is available in other EEA states, that one complaint originated in another Member State, and that Finland acted as lead supervisory authority — a clear one-stop-shop case even though the press release doesn't use the words "Article 60."

**EU-010 (AKI CCTV case)** — Year is uncertain. The case number (2.1.-1/22/1396) suggests a 2022 filing/decision, but the only English-language coverage I found is from mid-2023. Coded year as 2022 based on the case number convention, but this needs confirming against the original Estonian-language decision before the paper relies on it — see `docs/sources.md`.

**General note on this batch (EU-001 to EU-010):** these ten rows were seeded via secondary sources found through web search (GDPRhub, law firm client alerts, official regulator press releases), not by reading each original decision end-to-end as Step 3 of the guide requires. Treat this as a starting draft, not finished coding. Before scaling to 30 cases, go back through each of these against its primary source (linked in `docs/sources.md`) and correct anything a full read of the decision changes.
