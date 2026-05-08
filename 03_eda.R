# Load in cleaned data
source("02_clean_data.R")
install.packages("ggplot2") 
install.packages("scales")

# Cross Tab of Exposure x Outcome
table(chs$insured_factor, chs$no_care)
prop.table(table(chs$insured_factor, chs$no_care), 1)

# Stratify by age
for (age in levels(chs$age_group)) {
  cat("\nAge Group:", age, "\n")
  
  tab <- table(chs$insured_factor[chs$age_group == age],
               chs$no_care[chs$age_group == age])
  
  print(prop.table(tab, 1))
}

# Stratify by Sex
for (s in levels(chs$sex)) {
  cat("\nSex:", s, "\n")
  
  tab <- table(chs$insured_factor[chs$sex == s],
               chs$no_care[chs$sex == s])
  
  print(prop.table(tab, 1))
}

# Stratify by Poverty Level
for (p in levels(chs$poverty)) {
  cat("\nPoverty Group:", p, "\n")
  
  tab <- table(chs$insured_factor[chs$poverty == p],
               chs$no_care[chs$poverty == p])
  
  print(prop.table(tab, 1))
}

# -------------------------
# Visualization
# -------------------------

library(ggplot2)
library(scales)

summary_data <- as.data.frame(
  prop.table(table(chs$insured_factor, chs$no_care), 1)
)

colnames(summary_data) <- c("Insurance", "NoCare", "Proportion")

summary_data <- subset(summary_data, NoCare == "Yes")

unmet_care_plot <- ggplot(summary_data, aes(x = Insurance, y = Proportion, fill = Insurance)) +
  geom_bar(stat = "identity") +
  geom_text(aes(label = percent(Proportion, accuracy = 0.1)),
            vjust = -0.5) +
  scale_y_continuous(labels = percent) +
  labs(
    title = "Unmet Medical Need by Insurance Status (NYC CHS 2020)",
    x = "Insurance Status",
    y = "Percent Not Receiving Needed Care"
  ) +
  theme(legend.position = "none")

unmet_care_plot

# Save plot
ggsave("output/unmet_care_by_insurance.png",
       plot = unmet_care_plot,
       width = 6,
       height = 4)
