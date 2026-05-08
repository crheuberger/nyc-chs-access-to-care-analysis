# =========================
# 04_analysis.R
# Logistic Regression
# =========================

source("02_clean_data.R")
library(dplyr)
library(broom)
library(ggplot2)

# -------------------------
# Create binary outcome
# -------------------------

# Outcome: 1 = did not receive needed care, 0 = received needed care
chs$no_care_binary <- ifelse(chs$didntgetcare20 == 1, 1,
                             ifelse(chs$didntgetcare20 == 2, 0, NA))

table(chs$no_care_binary, useNA = "ifany")


# -------------------------
# Unadjusted logistic regression
# -------------------------

model_unadjusted <- glm(
  no_care_binary ~ insured_factor,
  data = chs,
  family = binomial
)

summary(model_unadjusted)


# Odds ratios and 95% confidence intervals
or_unadjusted <- exp(cbind(
  OR = coef(model_unadjusted),
  confint(model_unadjusted)
))

or_unadjusted


# -------------------------
# Adjusted logistic regression
# Model 1: Adjusted for age, sex, and poverty
# -------------------------

model_adjusted <- glm(
  no_care_binary ~ insured_factor + age_group + sex + poverty,
  data = chs,
  family = binomial
)

summary(model_adjusted)


# -------------------------
# Adjusted logistic regression
# Model 2: Also adjusted for race/ethnicity
# -------------------------

model_adjusted_race <- glm(
  no_care_binary ~ insured_factor + age_group + sex + poverty + race,
  data = chs,
  family = binomial
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


# -------------------------
# Save results
# -------------------------

if (!dir.exists("output")) {
  dir.create("output")
}

write.csv(or_unadjusted,
          "output/logistic_regression_unadjusted.csv",
          row.names = FALSE)

write.csv(or_adjusted,
          "output/logistic_regression_adjusted.csv",
          row.names = FALSE)

write.csv(or_adjusted_race,
          "output/logistic_regression_adjusted_race.csv",
          row.names = FALSE)


# -------------------------
# Forest plot for fully adjusted model
# -------------------------
# -------------------------
# Forest plot for fully adjusted model
# -------------------------

forest_data <- or_adjusted_race %>%
  filter(term != "(Intercept)") %>%
  mutate(
    term_clean = case_when(
      
      term == "insured_factorNo" ~ "Uninsured",
      
      term == "sexFemale" ~ "Female",
      
      term == "age_group2" ~ "Age Group 2",
      term == "age_group3" ~ "Age Group 3",
      term == "age_group4" ~ "Age Group 4",
      
      term == "poverty2" ~ "100–199% FPL",
      term == "poverty3" ~ "200–399% FPL",
      term == "poverty4" ~ "400–599% FPL",
      term == "poverty5" ~ "600%+ FPL",
      
      term == "race2" ~ "Race Group 2",
      term == "race3" ~ "Race Group 3",
      term == "race4" ~ "Race Group 4",
      term == "race5" ~ "Race Group 5",
      
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
    width = 0.2,
    orientation = "y"
  ) +
  geom_vline(xintercept = 1, linetype = "dashed") +
  scale_x_log10() +
  labs(
    title = "Adjusted Odds Ratios for Unmet Medical Need",
    subtitle = "NYC Community Health Survey, 2020",
    x = "Odds Ratio (log scale)",
    y = ""
  ) +
  theme_minimal()

# Display plot
print(forest_plot)

# Save plot
ggsave(
  filename = "output/adjusted_odds_ratios_forest_plot.png",
  plot = forest_plot,
  width = 8,
  height = 6
)
