# =========================
# 03_eda.R
# Weighted EDA and plots
# =========================

source("02_clean_data.R")

library(survey)
library(ggplot2)
library(scales)

# -------------------------
# Create binary outcome
# -------------------------

chs$no_care_binary <- ifelse(
  chs$didntgetcare20 == 1, 1,
  ifelse(chs$didntgetcare20 == 2, 0, NA)
)

# -------------------------
# Label poverty variable
# -------------------------

chs$poverty <- factor(
  chs$imputed_povertygroup,
  levels = c(1, 2, 3, 4, 5),
  labels = c(
    "<100% FPL",
    "100–199% FPL",
    "200–399% FPL",
    "400–599% FPL",
    "600%+ FPL"
  )
)

# -------------------------
# Create survey design object
# -------------------------

chs_design <- svydesign(
  ids = ~1,
  strata = ~strata,
  weights = ~wt21_dual,
  data = chs,
  nest = TRUE
)

# -------------------------
# Weighted prevalence by insurance
# -------------------------

weighted_insurance <- svyby(
  ~no_care_binary,
  ~insured_factor,
  chs_design,
  svymean,
  na.rm = TRUE,
  vartype = c("ci")
)

weighted_insurance

# -------------------------
# Weighted prevalence by insurance and poverty
# -------------------------

weighted_poverty <- svyby(
  ~no_care_binary,
  ~insured_factor + poverty,
  chs_design,
  svymean,
  na.rm = TRUE,
  vartype = c("ci")
)

weighted_poverty

# -------------------------
# Set plot colors
# -------------------------

insurance_colors <- c(
  "Yes" = "#4E79A7",
  "No" = "#E15759"
)

# -------------------------
# Visualization 1:
# Unmet care by insurance
# -------------------------

unmet_care_plot <- ggplot(
  weighted_insurance,
  aes(x = insured_factor, y = no_care_binary, fill = insured_factor)
) +
  geom_col(width = 0.65) +
  geom_errorbar(
    aes(ymin = ci_l, ymax = ci_u),
    width = 0.15
  ) +
  geom_text(
    aes(label = percent(no_care_binary, accuracy = 0.1)),
    vjust = -0.6,
    size = 4
  ) +
  scale_y_continuous(
    labels = percent,
    limits = c(0, max(weighted_insurance$ci_u, na.rm = TRUE) + 0.03)
  ) +
  scale_fill_manual(values = insurance_colors) +
  labs(
    title = "Weighted Prevalence of Unmet Medical Need by Insurance Status",
    subtitle = "NYC Community Health Survey, 2020",
    x = "Insurance Status",
    y = "Weighted Prevalence",
    fill = "Insurance Status"
  ) +
  theme_minimal(base_size = 12) +
  theme(
    legend.position = "none",
    plot.title = element_text(face = "bold"),
    plot.subtitle = element_text(size = 11),
    panel.grid.minor = element_blank()
  )

unmet_care_plot

if (!dir.exists("output")) {
  dir.create("output")
}

ggsave(
  "output/unmet_care_by_insurance_weighted.png",
  plot = unmet_care_plot,
  width = 6,
  height = 4
)

# -------------------------
# Visualization 2:
# Unmet care by insurance and poverty
# -------------------------

poverty_plot <- ggplot(
  weighted_poverty,
  aes(x = poverty, y = no_care_binary, fill = insured_factor)
) +
  geom_col(
    position = position_dodge(width = 0.8),
    width = 0.7
  ) +
  geom_errorbar(
    aes(ymin = ci_l, ymax = ci_u),
    position = position_dodge(width = 0.8),
    width = 0.2
  ) +
  geom_text(
    aes(label = percent(no_care_binary, accuracy = 0.1)),
    position = position_dodge(width = 0.8),
    vjust = -0.6,
    size = 3
  ) +
  scale_y_continuous(
    labels = percent,
    limits = c(0, max(weighted_poverty$ci_u, na.rm = TRUE) + 0.04)
  ) +
  scale_fill_manual(values = insurance_colors) +
  labs(
    title = "Weighted Prevalence of Unmet Medical Need by Insurance Status and Poverty Group",
    subtitle = "NYC Community Health Survey, 2020",
    x = "Poverty Group",
    y = "Weighted Prevalence",
    fill = "Insurance Status"
  ) +
  theme_minimal(base_size = 12) +
  theme(
    legend.position = "top",
    plot.title = element_text(face = "bold"),
    plot.subtitle = element_text(size = 11),
    axis.text.x = element_text(angle = 25, hjust = 1),
    panel.grid.minor = element_blank()
  )

poverty_plot

ggsave(
  "output/unmet_care_by_insurance_poverty_weighted.png",
  plot = poverty_plot,
  width = 8,
  height = 5
)
