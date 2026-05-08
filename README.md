# Access to Care and Insurance Status in NYC

## Background

This project examines the relationship between insurance status and unmet medical need among adults in New York City using data from the 2020 NYC Community Health Survey (CHS).

The analysis explores whether uninsured individuals are more likely to report not receiving needed medical care and evaluates the role of demographic and socioeconomic factors such as age, sex, and poverty status.

---

## Methods

Analyses were conducted in R using:

- Descriptive statistics
- Stratified analyses
- Logistic regression
- Data visualization with ggplot2

---

## Key Findings

- Uninsured respondents had higher odds of unmet medical need compared to insured respondents.
- After adjustment for age, sex, and poverty status, uninsured respondents had 1.45 times the odds of reporting unmet medical need.
- Lower-income respondents experienced higher unmet need even among the insured.

---

## Data Source

New York City Community Health Survey (CHS) 2020

---

## Repository Structure

- `01_load_data.R` — loads raw CHS SAS dataset
- `02_clean_data.R` — cleans and recodes analytic variables
- `03_eda.R` — exploratory analyses and visualizations
- `04_analysis.R` — logistic regression analyses

---

## Example Visualization
### Unmet Medical Need by Insurance Status

![Insurance Plot](unmet_care_by_insurance.png)

### Unmet Medical Need by Insurance Status and Poverty

![Poverty Plot](unmet_care_by_insurance_poverty.png)
