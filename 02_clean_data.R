# Load in data
source("01_load_data.R")

# Exposure- Insurance
table(chs$insured, useNA = "ifany")
unique(chs$insured)
class(chs$insured)

chs$insured_factor <- factor(chs$insured,
                             levels = c(1, 2),
                             labels = c("Yes", "No"))

table(chs$insured_factor, useNA= "ifany")

# Outcome- Needed medical care in last 12 months, did not get it

chs$no_care <- factor(chs$didntgetcare20,
                      levels = c(1, 2),
                      labels = c("Yes", "No"))

# Covariates
chs$age_group <- factor(chs$agegroup)

chs$sex <- factor(chs$birthsex,
                  levels = c(1, 2),
                  labels = c("Male", "Female"))

chs$race <- factor(chs$newrace)

chs$poverty <- factor(chs$imputed_povertygroup)

# Check everything
table(chs$insured_factor, useNA = "ifany")
table(chs$no_care, useNA = "ifany")
