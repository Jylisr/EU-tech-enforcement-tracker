# ============================================================
# EU Tech Enforcement Tracker
# enforcement_analysis.R
#
# Descriptive analysis of GDPR enforcement decisions across
# EU Member States, with focus on non-material damages patterns.
# ============================================================

library(tidyverse)

# ── 1. LOAD DATA ─────────────────────────────────────────────

data_path <- file.path(dirname(rstudioapi::getActiveDocumentContext()$path),
                        "..", "data", "enforcement_data.csv")

# Fallback for non-RStudio environments
if (!exists("data_path") || !file.exists(data_path)) {
  data_path <- "data/enforcement_data.csv"
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
cat("Member States covered:", nlevels(df$member_state), "\n")
cat("Years covered:", min(df$year), "-", max(df$year), "\n\n")

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

# Filter to Art. 82 cases with damages awarded
art82 <- df |>
  filter(legal_basis == "Art. 82", !is.na(damages_awarded))

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

# ── 4. VISUALISATIONS ────────────────────────────────────────

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

ggsave("analysis/plot_damages_by_state.png", p1, width = 8, height = 5, dpi = 150)
cat("\nSaved: plot_damages_by_state.png\n")

# 4b. Decisions by sector and enforcing body
p2 <- df |>
  count(sector, enforcing_body) |>
  ggplot(aes(x = sector, y = n, fill = enforcing_body)) +
  geom_col(position = "dodge", width = 0.6) +
  scale_fill_manual(values = c("Court" = "#1a5fb4", "DPA" = "#c0392b"),
                    name = "Enforcing Body") +
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

ggsave("analysis/plot_sector_enforcer.png", p2, width = 8, height = 5, dpi = 150)
cat("Saved: plot_sector_enforcer.png\n")

# 4c. Yearly trend in private enforcement
p3 <- df |>
  filter(legal_basis == "Art. 82") |>
  count(year, member_state) |>
  ggplot(aes(x = year, y = n, color = member_state, group = member_state)) +
  geom_line(linewidth = 0.8) +
  geom_point(size = 2.5) +
  scale_color_brewer(palette = "Set1", name = "Member State") +
  scale_x_continuous(breaks = unique(df$year)) +
  labs(
    title    = "Art. 82 GDPR Private Enforcement: Annual Trend",
    subtitle = "Decisions per Member State",
    x        = "Year",
    y        = "Number of Decisions",
    caption  = "Source: EU Tech Enforcement Tracker dataset"
  ) +
  theme_minimal(base_size = 12) +
  theme(
    plot.title    = element_text(face = "bold", size = 13),
    plot.subtitle = element_text(color = "grey40"),
    legend.position = "right"
  )

ggsave("analysis/plot_yearly_trend.png", p3, width = 8, height = 5, dpi = 150)
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
