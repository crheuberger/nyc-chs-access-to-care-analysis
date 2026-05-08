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

## Results

In unadjusted logistic regression analyses, uninsured respondents had 1.68 times the odds of reporting unmet medical need compared to insured respondents.

After adjusting for age, sex, poverty status, and race/ethnicity, uninsured respondents continued to have higher odds of unmet medical need.

Lower-income respondents experienced higher levels of unmet medical need even among the insured, suggesting that socioeconomic barriers to care persist beyond insurance coverage alone.

Several demographic and socioeconomic variables showed meaningful differences in odds of unmet medical need, highlighting the complex factors associated with healthcare access in NYC.

---

## Example Visualization
### Unmet Medical Need by Insurance Status

![Insurance Plot](unmet_care_by_insurance.png)

### Unmet Medical Need by Insurance Status and Poverty

![Poverty Plot](unmet_care_by_insurance_poverty.png)

### Adjusted Odds Ratios for Unmet Medical Need
![Adjusted Odds Ratios](output/adjusted_odds_ratios_forest_plot.png)

---

## Repository Structure

- `01_load_data.R` — loads raw CHS SAS dataset
- `02_clean_data.R` — cleans and recodes analytic variables
- `03_eda.R` — exploratory analyses and visualizations
- `04_analysis.R` — logistic regression analyses

---

## Data Source

Data were obtained from the 2020 NYC Community Health Survey (CHS).

The raw dataset is not included in this repository. Publicly available CHS data can be accessed through the NYC Department of Health.
