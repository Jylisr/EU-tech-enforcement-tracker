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

---

### Part 2 note: running the analysis script against real data surfaced two more bugs

Running `analysis/enforcement_analysis.R` against the actual seeded dataset
(rather than just reading the code) found two problems the earlier read-through
missed:

1. The yearly-trend chart (`p3`) filtered on `legal_basis == "Art. 82"` —
   an exact-match filter that silently excluded every case where Art. 82 was
   listed alongside other articles (e.g. `"Art. 82; Art. 9"`). Since most of
   our Art. 82 cases have a co-listed article, this chart was built from 1
   row instead of 4. Fixed to use `str_detect()`, matching the fix already
   made to the `art82` filter earlier in the script.
2. The sector/enforcer chart's fill scale was hardcoded to `"Court"` /
   `"DPA"`, but the actual `enforcing_body` values per the coding rules are
   `court_first_instance`, `court_appeal`, `DPA`, `EDPB` — so every court
   case was rendering with no assigned colour. Switched to
   `scale_fill_brewer()` so it works with whatever enforcing_body values
   are actually in the data.

Lesson for later: read-through review of a script isn't a substitute for
running it against real data — both of these bugs were invisible until the
schema's actual category values were plugged in.

---

### Batch 2 (EU-011 to EU-014): expanding toward n=30

**EU-011 (McCabe v AA Ireland)** — Same sector question as EU-001/EU-002: an employee's covert-recording and access-rights dispute with their employer, not really a "digital sector" case. Coded `other` for consistency with the earlier employer-context rule.

**EU-012 (Dillon v Irish Life Assurance)** — This is a procedural Supreme Court ruling (whether PIAB authorisation is required), not a merits decision — the underlying Article 82 claim has been remitted and has not yet been decided. `damages_awarded` coded NA and `harm_type` coded `none_found`, but this is a coding compromise, not an accurate description: `none_found` normally means "the court considered the harm and found none," and that's not what happened here — the court hasn't reached the harm question yet. Flagged in `sources.md` to revisit once the substantive claim is decided. New rule under consideration: the schema may need a `harm_type` value like `not_yet_decided` distinct from `none_found` if more procedural-only rulings like this get coded — worth deciding before the next batch rather than continuing to overload `none_found`.

**EU-013 (OLG Dresden 4 U 808/24)** — Another Facebook/Meta scraping case, this time at the appellate level and post-dating the German Federal Court of Justice's November 2024 clarification (BGH VI ZR 10/24) that mere loss of control counts as non-material damage. Coded cross_border TRUE on the same basis as EU-003. Note for the expanded dataset: German scraping cases are turning out to be a large and fairly homogeneous cluster (EU-003, EU-004 is unrelated but EU-013 and probably many more like it exist) — worth deciding whether to cap how many near-identical scraping cases get included, since they may not add much variance to the sample even as they add to n.

**EU-014 (CA Chambéry, Google My Business case)** — This decision recognised both moral harm (anxiety, loss of control over professional identity) and material harm (cost of repeated efforts to get the listing removed) as distinct components of the €10,000 award. Coded `harm_type` as `multiple` rather than defaulting to `non_material`, since the decision was explicit about both components rather than leaving the harm type unspecified. Sector coded as `adtech`, but this is a lower-confidence call — Google My Business is a business-directory/reviews product rather than display advertising in the strict sense — flagged in `sources.md`.

**Scope note:** three additional cases supplied (a UK Court of Appeal case, a Dutch district court case, and a Spanish AEPD case) were not added — UK GDPR is a different legal regime post-Brexit, and Netherlands/Spain are outside the five-state design in `coding_rules.md`. See the exclusion table in `sources.md`. If the project's scope is deliberately expanded beyond the original five states, these should be revisited and the coding_rules.md unit-of-analysis section updated accordingly rather than adding states ad hoc.

---

### Batch 3 (schema v2): scope expansion to all EU states, corrections, and 14 new cases

The project owner supplied a document of GDPRhub entries and confirmed the
scope should expand beyond the original five states, since GDPRhub simply
doesn't have enough five-state coverage to reach a usable sample. This
batch required more structural changes than the previous two, recorded
here in full since several of them affect the schema itself, not just
individual rows.

**Schema changes.** Added `ecli`, added `fine_amount` as distinct from
`damages_awarded`, added `not_yet_decided` as a `harm_type` value. Full
rationale for each is in `coding_rules.md` — not repeating it here, but
flagging that these are retroactive: existing rows were revisited, not
just new ones.

**EU-012 (Dillon) recoded.** Originally coded `harm_type = none_found`,
with a note at the time that this was a compromise since the case is
procedural only. Now that `not_yet_decided` exists, recoded to that value
— this is the case that motivated adding the category in the first place.

**EU-013 (OLG Dresden) legal_basis corrected.** Originally coded as "Art.
82; Art. 5" based on an earlier, less precise secondary source. The
project owner's document lists the actual relevant law as Art. 6, 15,
25(2), and 82 — corrected accordingly. The €100 damages figure from the
original coding is retained since this document doesn't state an amount
either way, but is now flagged for direct verification in `sources.md`
since neither source has fully confirmed it.

**EU-014 (Chambéry) damages corrected from €10,000 to €50,000.** This is
a large enough discrepancy to be worth stating plainly: the original
figure came from a secondary law-firm-style write-up (Village Justice);
the project owner's document — sourced more directly from GDPRhub — states
€50,000. Using €50,000 as the better-sourced figure, but this is exactly
the kind of error the verification checklist in `sources.md` exists to
catch, and it should be confirmed against the actual judgment text before
either number is trusted in the paper.

**EU-016 (AEPD Spain) — case number conflict in the source itself.** The
page title says EXP202311911; the metadata block on the same page says
EXP202304821. Not a coding decision on my part — flagged in `sources.md`
for the project owner to resolve against aepd.es directly, since I can't
tell which is the typo from the information available.

**EU-017 (CNIL / Apple) — legal_basis deliberately excludes "Art. 82."**
The underlying fine is issued under Article 82 of the French Data
Protection Act (LIL), which transposes the ePrivacy Directive's
cookie-consent rules — a different Article 82 from GDPR Article 82
damages, despite the identical number. Writing "Art. 82" into the
`legal_basis` field would cause this row to be wrongly swept into every
GDPR Art. 82 filter in the analysis script (`str_detect("Art\\. 82")`).
Coded `legal_basis = "Art. 6"` instead (the GDPR consent-lawfulness
article genuinely at issue) and noted the LIL Art. 82 point here instead.
This is the kind of silent contamination that's very easy to miss —
worth double-checking no other national-law citation in this batch has
the same problem before adding more DPA cases.

**EU-018 (VDAI Lithuania) — fine amount conflict in the source itself.**
Metadata block says "110 EUR"; summary paragraph says "€110,000" — a
1000x discrepancy, clearly one is a typo, but I can't tell which from the
information given. Rather than guess a number that would end up in the
dataset's fine-amount statistics, left `fine_amount` as NA and flagged
the conflict in `sources.md`.

**EU-020 (Amtsgericht München / "BayLfD") — authority field overridden.**
GDPRhub's own structured metadata labels this a decision by BayLfD, the
Bavarian DPA. The plain-text summary on the same page says "The District
Court of Munich dismissed a data subject's claims" — a court, not a DPA,
and the ZAG/BGB payment-law citations in the "Relevant Law" field are
consistent with a civil court judgment, not administrative enforcement.
Coded `authority = "Amtsgericht München"` and `enforcing_body =
court_first_instance`, following what the case description actually
says rather than the label. Flagged as needing direct confirmation
either way — this could equally be my misreading of an unusual
dual-track case rather than a genuine GDPRhub labelling error.

**EU-022 (Rb. Den Haag) and EU-023 (Cassazione, Italy) — coded
`not_yet_decided`.** Both summaries describe a legal principle or
choice-of-law question being resolved without stating the resulting
damages figure for that specific case. Rather than assume no damages were
awarded (`none_found`, which asserts a negative finding that isn't
actually stated), coded both as `not_yet_decided` and flagged for
follow-up. This may turn out to be wrong in either direction once the
full judgments are read — these are provisional codings based on
incomplete summaries, not confirmed outcomes.

**EU-026 (OLG Koblenz) — year corrected from source's stated 2018 to
2022.** The source document lists "Decided: 22.05.2018", which conflicts
with everything else on the same line: the case number ends "/21"
(consistent with a 2021 filing), the appeal is from a same-era LG Koblenz
case, and the ECLI itself — `ECLI:DE:OLGKOBL:2022:0518.5U2141.21.00` —
encodes the decision date as 2022-05-18 in its own string. This looks
like a straightforward transposition error in the source (day and year
digits swapped) rather than a genuine 2018 decision about a 2021-numbered
case. Corrected to 2022, trusting the ECLI as the most structurally
reliable piece of information available, and flagged for direct
confirmation.

**Currency conversions (EU-024, EU-025, EU-027).** Three cases were
reported in PLN or HUF with a EUR conversion already supplied secondhand
(€6,500 for PLN 30,000; €9,300 for PLN 40,000; €204,000 for HUF
80,000,000). Used the supplied conversions rather than recalculating, but
flagged all three in `sources.md` since exchange rates move and the
"correct" conversion depends on the rate at the time of the judgment, not
today's.

**Sector taxonomy gaps.** Two more categories of controller didn't fit
the existing sector list this batch: telecoms (EU-016, SIM/mobile
carrier) and hospitality (EU-024, hotel). Both coded `other` for now,
noted in `coding_rules.md`. If more telecom or hospitality cases turn up,
worth adding dedicated categories rather than letting `other` become a
catch-all that hides real sectoral patterns.

**What was not done this batch, per the project owner's instruction:** the
R analysis script, README, and paper draft were deliberately left
untouched. All three now describe a ten- or fourteen-case, five-state
dataset that no longer matches `enforcement_data.csv` (28 cases, 12
states). That mismatch is intentional for now and should be resolved in
the next pass, not left indefinitely.
