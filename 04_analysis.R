# =========================
# 04_analysis.R
# Survey-Weighted Logistic Regression
# =========================

source("02_clean_data.R")

library(survey)
library(dplyr)
library(broom)
library(ggplot2)

# -------------------------
# Create binary outcome
# -------------------------

# Outcome: 1 = did not receive needed care, 0 = received needed care
chs$no_care_binary <- ifelse(
  chs$didntgetcare20 == 1, 1,
  ifelse(chs$didntgetcare20 == 2, 0, NA)
)

table(chs$no_care_binary, useNA = "ifany")

# -------------------------
# Relabel poverty variable
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
# Model 1: Unadjusted weighted logistic regression
# -------------------------

model_unadjusted <- svyglm(
  no_care_binary ~ insured_factor,
  design = chs_design,
  family = quasibinomial()
)

summary(model_unadjusted)

# -------------------------
# Model 2: Adjusted for age, sex, and poverty
# -------------------------

model_adjusted <- svyglm(
  no_care_binary ~ insured_factor + age_group + sex + poverty,
  design = chs_design,
  family = quasibinomial()
)

summary(model_adjusted)

# -------------------------
# Model 3: Also adjusted for race/ethnicity
# -------------------------

model_adjusted_race <- svyglm(
  no_care_binary ~ insured_factor + age_group + sex + poverty + race,
  design = chs_design,
  family = quasibinomial()
)

summary(model_adjusted_race)

# -------------------------
# Create clean odds ratio tables
# -------------------------

or_unadjusted <- tidy(
  model_unadjusted,
  exponentiate = TRUE,
  conf.int = TRUE
)

or_adjusted <- tidy(
  model_adjusted,
  exponentiate = TRUE,
  conf.int = TRUE
)

or_adjusted_race <- tidy(
  model_adjusted_race,
  exponentiate = TRUE,
  conf.int = TRUE
)

or_unadjusted
or_adjusted
or_adjusted_race

# -------------------------
# Save results
# -------------------------

if (!dir.exists("output")) {
  dir.create("output")
}

write.csv(
  or_unadjusted,
  "output/logistic_regression_unadjusted_weighted.csv",
  row.names = FALSE
)

write.csv(
  or_adjusted,
  "output/logistic_regression_adjusted_weighted.csv",
  row.names = FALSE
)

write.csv(
  or_adjusted_race,
  "output/logistic_regression_adjusted_race_weighted.csv",
  row.names = FALSE
)

# -------------------------
# Forest plot for fully adjusted weighted model
# -------------------------

forest_data <- or_adjusted_race %>%
  filter(term != "(Intercept)") %>%
  mutate(
    term_clean = case_when(
      
      # Insurance
      term == "insured_factorNo" ~ "Uninsured",
      
      # Sex
      term == "sexFemale" ~ "Female",
      
      # Age
      term == "age_group25–44" ~ "Age 25–44",
      term == "age_group45–64" ~ "Age 45–64",
      term == "age_group65+" ~ "Age 65+",
      
      # Poverty
      term == "poverty100–199% FPL" ~ "100–199% FPL",
      term == "poverty200–399% FPL" ~ "200–399% FPL",
      term == "poverty400–599% FPL" ~ "400–599% FPL",
      term == "poverty600%+ FPL" ~ "600%+ FPL",
      
      # Race
      term == "raceBlack" ~ "Black",
      term == "raceHispanic" ~ "Hispanic",
      term == "raceAsian/PI" ~ "Asian/Pacific Islander",
      term == "raceOther" ~ "Other Race",
      
      TRUE ~ term
    )
  )

forest_plot <- ggplot(
  forest_data,
  aes(
    x = estimate,
    y = reorder(term_clean, estimate)
  )
) +
  geom_point() +
  geom_errorbar(
    aes(xmin = conf.low, xmax = conf.high),
    width = 0.2
  ) +
  geom_vline(xintercept = 1, linetype = "dashed") +
  scale_x_log10() +
  labs(
    title = "Survey-Weighted Adjusted Odds Ratios for Unmet Medical Need",
    subtitle = "NYC Community Health Survey, 2020",
    x = "Odds Ratio (log scale)",
    y = ""
  ) +
  theme_minimal()

print(forest_plot)

ggsave(
  filename = "output/adjusted_odds_ratios_forest_plot_weighted.png",
  plot = forest_plot,
  width = 8,
  height = 6
)

