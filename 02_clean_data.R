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

# -------------------------
# Covariates
# -------------------------

# Age group
chs$age_group <- factor(
  chs$agegroup,
  levels = c(1, 2, 3, 4),
  labels = c(
    "18–24",
    "25–44",
    "45–64",
    "65+"
  )
)

# Sex assigned at birth
chs$sex <- factor(
  chs$birthsex,
  levels = c(1, 2),
  labels = c("Male", "Female")
)

# Race/ethnicity
chs$race <- factor(
  chs$newrace,
  levels = c(1, 2, 3, 4, 5),
  labels = c(
    "White",
    "Black",
    "Hispanic",
    "Asian/PI",
    "Other"
  )
)

# Household poverty level
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

# Check covariates
table(chs$age_group, useNA = "ifany")
table(chs$sex, useNA = "ifany")
table(chs$race, useNA = "ifany")
table(chs$poverty, useNA = "ifany")
