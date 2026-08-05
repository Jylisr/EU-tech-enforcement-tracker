# ============================================================
# EU Tech Enforcement Tracker
# enforcement_analysis.R
#
# Descriptive analysis of GDPR enforcement decisions across
# EU Member States, with focus on non-material damages patterns.
# ============================================================

library(tidyverse)

# ── 1. LOAD DATA ─────────────────────────────────────────────

data_path <- "data/enforcement_data.csv"

# If running interactively from RStudio and the relative path above doesn't
# resolve (e.g. working directory isn't the repo root), try to locate the
# file relative to the currently open script instead.
if (!file.exists(data_path) && requireNamespace("rstudioapi", quietly = TRUE) &&
    rstudioapi::isAvailable()) {
  doc_path <- tryCatch(rstudioapi::getActiveDocumentContext()$path, error = function(e) "")
  if (nzchar(doc_path)) {
    candidate <- file.path(dirname(doc_path), "..", "data", "enforcement_data.csv")
    if (file.exists(candidate)) data_path <- candidate
  }
}

if (!file.exists(data_path)) {
  stop("Could not find data/enforcement_data.csv. Run this script from the ",
       "repo root, or check that the dataset has been created.")
}

df <- read_csv(data_path, show_col_types = FALSE) |>
  mutate(
    member_state = factor(member_state),
    sector       = factor(sector),
    harm_type    = factor(harm_type),
    enforcing_body = factor(enforcing_body),
    cross_border = as.logical(cross_border)
  )

cat("Dataset loaded:", nrow(df), "decisions\n")

if (nrow(df) == 0) {
  stop("enforcement_data.csv has no rows yet. Code at least 10 real cases ",
       "(Part 1 of the guide) before running this analysis — the file ",
       "currently only has the column headers.")
}

cat("Member States covered:", nlevels(df$member_state), "\n")
cat("Years covered:", min(df$year), "-", max(df$year), "\n")
cat("harm_type breakdown:\n")
print(table(df$harm_type))
if ("not_yet_decided" %in% df$harm_type) {
  n_pending <- sum(df$harm_type == "not_yet_decided")
  cat("\nNote:", n_pending, "case(s) are procedural rulings with the merits",
      "not yet decided (harm_type = not_yet_decided). These are excluded",
      "from damages figures below but still count as enforcement decisions.\n")
}
cat("\n")

# ── 2. OVERVIEW ──────────────────────────────────────────────

# Decisions by member state
decisions_by_state <- df |>
  count(member_state, name = "n_decisions") |>
  arrange(desc(n_decisions))

cat("Decisions by Member State:\n")
print(decisions_by_state)

# Decisions by sector
decisions_by_sector <- df |>
  count(sector, name = "n_decisions") |>
  arrange(desc(n_decisions))

cat("\nDecisions by Sector:\n")
print(decisions_by_sector)

# ── 3. PRIVATE ENFORCEMENT (ART. 82) ─────────────────────────

# Filter to Art. 82 cases with damages awarded.
# legal_basis may list multiple articles separated by semicolons (primary
# article first per the coding rules), so match anywhere in the string
# rather than requiring an exact match.
art82 <- df |>
  filter(str_detect(legal_basis, "Art\\. 82"), !is.na(damages_awarded))

cat("\nArt. 82 cases with damages awarded:", nrow(art82), "\n\n")

# Damages by member state
damages_by_state <- art82 |>
  group_by(member_state) |>
  summarise(
    n_cases       = n(),
    mean_damages  = round(mean(damages_awarded), 0),
    median_damages = median(damages_awarded),
    min_damages   = min(damages_awarded),
    max_damages   = max(damages_awarded),
    .groups = "drop"
  ) |>
  arrange(desc(median_damages))

cat("Non-material damages by Member State (Art. 82 cases):\n")
print(damages_by_state)

# ── 3b. ADMINISTRATIVE FINES (ART. 83) ───────────────────────
# Separate from Art. 82 damages above: this is money paid to the state by
# the controller, not compensation paid to the data subject. Never
# combine these two figures — see coding_rules.md.

fines <- df |>
  filter(!is.na(fine_amount))

cat("\nDPA administrative fines recorded:", nrow(fines), "\n")

if (nrow(fines) > 0) {
  fines_by_state <- fines |>
    group_by(member_state) |>
    summarise(
      n_cases    = n(),
      mean_fine  = round(mean(fine_amount), 0),
      median_fine = median(fine_amount),
      min_fine   = min(fine_amount),
      max_fine   = max(fine_amount),
      .groups = "drop"
    ) |>
    arrange(desc(median_fine))

  cat("Administrative fines by Member State:\n")
  print(fines_by_state)
}

# ── 4. VISUALISATIONS ────────────────────────────────────────

dir.create("analysis", showWarnings = FALSE)
dir.create("output", showWarnings = FALSE)

# 4a. Damages distribution by member state
p1 <- art82 |>
  ggplot(aes(x = fct_reorder(member_state, damages_awarded, median),
             y = damages_awarded)) +
  geom_boxplot(fill = "#d6e4f0", color = "#2c5f8a", outlier.shape = 16,
               outlier.color = "#2c5f8a", width = 0.5) +
  geom_jitter(width = 0.15, alpha = 0.6, color = "#1a5fb4", size = 2) +
  coord_flip() +
  labs(
    title    = "Non-material Damages Awarded under Art. 82 GDPR",
    subtitle = "Distribution by Member State",
    x        = NULL,
    y        = "Damages Awarded (EUR)",
    caption  = "Source: EU Tech Enforcement Tracker dataset"
  ) +
  theme_minimal(base_size = 12) +
  theme(
    plot.title    = element_text(face = "bold", size = 13),
    plot.subtitle = element_text(color = "grey40"),
    panel.grid.major.y = element_blank(),
    axis.text     = element_text(color = "grey30")
  )

ggsave("output/plot_damages_by_state.png", p1, width = 8, height = 5, dpi = 150)
cat("\nSaved: plot_damages_by_state.png\n")

# 4a-2. Administrative fines by member state (log scale — fines span
# €3,000 to €8,000,000, five orders of magnitude, so a linear axis would
# make everything below France and Estonia invisible)
if (nrow(fines) > 0) {
  p1b <- fines |>
    ggplot(aes(x = fct_reorder(member_state, fine_amount, median),
               y = fine_amount)) +
    geom_boxplot(fill = "#f0d6d6", color = "#8a2c2c", outlier.shape = 16,
                 outlier.color = "#8a2c2c", width = 0.5) +
    geom_jitter(width = 0.15, alpha = 0.6, color = "#b41a1a", size = 2) +
    scale_y_log10(labels = scales::label_comma()) +
    coord_flip() +
    labs(
      title    = "Administrative Fines under Art. 83 GDPR",
      subtitle = "Distribution by Member State (log scale — note the range)",
      x        = NULL,
      y        = "Fine Amount (EUR, log scale)",
      caption  = "Source: EU Tech Enforcement Tracker dataset"
    ) +
    theme_minimal(base_size = 12) +
    theme(
      plot.title    = element_text(face = "bold", size = 13),
      plot.subtitle = element_text(color = "grey40"),
      panel.grid.major.y = element_blank(),
      axis.text     = element_text(color = "grey30")
    )

  ggsave("output/plot_fines_by_state.png", p1b, width = 8, height = 5, dpi = 150)
  cat("Saved: plot_fines_by_state.png\n")
}

# 4b. Decisions by sector and enforcing body
p2 <- df |>
  count(sector, enforcing_body) |>
  ggplot(aes(x = sector, y = n, fill = enforcing_body)) +
  geom_col(position = "dodge", width = 0.6) +
  scale_fill_brewer(palette = "Set1", name = "Enforcing Body") +
  labs(
    title    = "Enforcement Decisions by Sector and Body",
    subtitle = "GDPR · Court vs. DPA decisions",
    x        = NULL,
    y        = "Number of Decisions",
    caption  = "Source: EU Tech Enforcement Tracker dataset"
  ) +
  theme_minimal(base_size = 12) +
  theme(
    plot.title    = element_text(face = "bold", size = 13),
    plot.subtitle = element_text(color = "grey40"),
    axis.text.x   = element_text(angle = 20, hjust = 1),
    legend.position = "top"
  )

ggsave("output/plot_sector_enforcer.png", p2, width = 8, height = 5, dpi = 150)
cat("Saved: plot_sector_enforcer.png\n")

# 4c. Yearly trend in private enforcement
# Filtering on legal_basis alone isn't enough now that DPA fine decisions
# can also cite Art. 82 as related law (e.g. Art. 82(2) joint-controller
# liability) without being a private damages claim at all. Restrict to
# court-litigated cases so this chart actually reflects private
# enforcement volume, not administrative fines that happen to mention the
# article in passing.
p3_data <- df |>
  filter(str_detect(legal_basis, "Art\\. 82"),
         enforcing_body %in% c("court_first_instance", "court_appeal")) |>
  count(year, member_state)

# A single overlaid line chart stopped being legible once the sample grew
# past ~4 states: several states have identical sparse single-count
# trajectories in adjacent years, so their lines and points land exactly
# on top of each other (e.g. France's and Poland's single 2025 case were
# rendering as one invisible point). Faceting by state avoids this and
# scales better as more states are added.
p3 <- p3_data |>
  ggplot(aes(x = year, y = n)) +
  geom_col(fill = "#1a5fb4", width = 0.6) +
  facet_wrap(~ member_state, nrow = 2) +
  scale_x_continuous(breaks = unique(df$year)) +
  scale_y_continuous(breaks = scales::breaks_pretty(n = 3)) +
  labs(
    title    = "Art. 82 GDPR Private Enforcement: Annual Trend",
    subtitle = "Court-litigated decisions per Member State, by year",
    x        = "Year",
    y        = "Number of Decisions",
    caption  = "Source: EU Tech Enforcement Tracker dataset"
  ) +
  theme_minimal(base_size = 12) +
  theme(
    plot.title    = element_text(face = "bold", size = 13),
    plot.subtitle = element_text(color = "grey40"),
    axis.text.x   = element_text(angle = 45, hjust = 1, size = 8),
    strip.text    = element_text(face = "bold")
  )

ggsave("output/plot_yearly_trend.png", p3, width = 8, height = 5, dpi = 150)
cat("Saved: plot_yearly_trend.png\n")

# ── 5. SUMMARY STATISTICS ────────────────────────────────────

cat("\n── Summary: Cross-border vs. Domestic Damages ──\n")
cross_border_summary <- art82 |>
  group_by(cross_border) |>
  summarise(
    n             = n(),
    mean_damages  = round(mean(damages_awarded), 0),
    median_damages = median(damages_awarded),
    .groups = "drop"
  )
print(cross_border_summary)

cat("\n── Violation Types in Art. 82 Cases ──\n")
art82 |>
  count(violation_type, sort = TRUE) |>
  print()

cat("\nAnalysis complete.\n")
