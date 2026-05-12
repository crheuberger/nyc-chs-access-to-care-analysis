# Access to Care and Insurance Status in NYC

## Background

Access to healthcare is a major determinant of health outcomes and preventive care utilization. Lack of insurance coverage and socioeconomic barriers may contribute to delays in receiving needed medical care, particularly among low-income populations.

This project examines the relationship between insurance status and unmet medical need among adults in New York City using data from the 2020 NYC Community Health Survey (CHS), a population-based public health survey conducted by the NYC Department of Health and Mental Hygiene.

The analysis explores whether uninsured individuals are more likely to report not receiving needed medical care and evaluates how demographic and socioeconomic factors such as age, sex, race/ethnicity, and poverty status are associated with healthcare access.

---

## Methods

The analysis was conducted in R and includes:

- Data cleaning and variable recoding
- Survey-weighted descriptive analysis
- Weighted prevalence estimation
- Survey-weighted logistic regression
- Data visualization using ggplot2

---

## Results

In survey-weighted unadjusted logistic regression analyses, uninsured NYC adults had higher odds of reporting unmet medical need compared with insured adults.

After adjusting for age, sex, poverty status, and race/ethnicity, uninsured respondents continued to have higher odds of unmet medical need, suggesting that insurance coverage remained independently associated with healthcare access.

Lower-income respondents experienced higher weighted prevalence of unmet medical need even among the insured, indicating that socioeconomic barriers to care persist beyond insurance coverage alone.

Survey-weighted analyses also demonstrated variation in unmet medical need across demographic groups, highlighting the complex social and structural factors associated with healthcare access in NYC.

---

## Example Visualization
### Unmet Medical Need by Insurance Status

![Insurance Plot](unmet_care_by_insurance_weighted.png)

### Unmet Medical Need by Insurance Status and Poverty

![Poverty Plot](unmet_care_by_insurance_poverty_weighted.png)

### Adjusted Odds Ratios for Unmet Medical Need
![Adjusted Odds Ratios](adjusted_odds_ratios_forest_plot_weighted.png)

---

## Repository Structure

- `01_load_data.R` — loads raw CHS SAS dataset
- `02_clean_data.R` — cleans and recodes analytic variables
- `03_eda.R` — weighted exploratory analyses and visualizations
- `04_analysis.R` — weighted logistic regression analyses

---

## Data Source

Data were obtained from the 2020 NYC Community Health Survey (CHS).

Analyses incorporated CHS survey weights and stratification variables to generate estimates representative of the NYC adult population.

The raw dataset is not included in this repository. Publicly available CHS data can be accessed through the NYC Department of Health.
