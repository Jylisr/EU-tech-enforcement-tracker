# EU Tech Enforcement Tracker

A structured dataset and analysis of GDPR and EU AI Act enforcement decisions across EU Member States.

## Purpose

This project tracks enforcement decisions in EU digital regulation (primarily GDPR) across multiple Member States and digital sectors. The goal is to examine how legal rules operate in practice and whether enforcement outcomes are consistent across jurisdictions.

## Research Question

To what extent do procedural and institutional differences across Member States produce divergent enforcement outcomes under EU digital regulation?

## Structure

```
EU-tech-enforcement-tracker/
├── data/
│   └── enforcement_data.csv     # Coded enforcement decisions
├── analysis/
│   └── enforcement_analysis.R   # Descriptive statistics and visualisations
└── README.md
```

## Variables

| Variable | Description |
|---|---|
| `case_id` | Unique identifier |
| `member_state` | EU Member State where decision was issued |
| `year` | Year of decision |
| `sector` | Digital sector (social media, adtech, fintech, health, other) |
| `legal_basis` | Primary GDPR article invoked |
| `violation_type` | Category of violation |
| `enforcing_body` | DPA or court |
| `damages_awarded` | Compensation awarded to data subject (EUR), if any |
| `harm_type` | Type of harm (non-material, material, reputational) |
| `cross_border` | Whether case involved cross-border processing |

## Preliminary Observation

Non-material damages thresholds vary significantly across Member States, suggesting inconsistent enforcement incentives and uneven practical access to remedies under Article 82 GDPR.

## Dependencies

- R (>= 4.1)
- `tidyverse`
- `ggplot2` (included in tidyverse)
- `knitr` (optional, for table output)

Install with:

```r
install.packages("tidyverse")
```

## Status

Active data collection. Dataset and analysis will be updated as new decisions are coded.
