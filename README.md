# Leptospirosis Surveillance Analytics

**Field Epidemiology Portfolio | R | Surveillance Analytics | Logistic Regression**

An end-to-end leptospirosis surveillance analytics portfolio based on real-world field epidemiology work in Bantul District, Indonesia.

A related ecological analysis of leptospirosis cases and rainfall patterns in Bantul District for 2020–2023 was previously published in **BIO Web of Conferences (2024)**. This portfolio extends that body of work by focusing on additional surveillance-process questions, including epidemiological investigation, laboratory testing, completeness, and onset-to-investigation delay.

> **Privacy note:** The public repository uses a fully synthetic demonstration dataset. Original patient-level surveillance records from the Bantul District Health Office are not included.

---

## Project Overview

This project demonstrates how routine infectious disease surveillance data can be transformed into actionable public health indicators using R.

The analysis focuses on:

- epidemiological investigation completeness;
- onset-to-investigation delay;
- laboratory testing completeness;
- annual surveillance trends;
- multivariable logistic regression; and
- reproducible data visualization.

---

## Related Published Work

A related analysis using leptospirosis surveillance data from Bantul District Health Office was previously published as:

**Examining the Impact of Rainfall Patterns on Leptospirosis Cases in Bantul District, Indonesia: A Four-Year Ecology Study 2020–2023**

BIO Web of Conferences. 2024;132:03002.  
DOI: https://doi.org/10.1051/bioconf/202413203002

The current portfolio continues the analytical exploration of leptospirosis surveillance using a different set of surveillance-performance questions.

---

## What I Did

- Built surveillance completeness indicators
- Assessed epidemiological investigation performance
- Analyzed onset-to-investigation delay
- Evaluated laboratory testing completeness
- Developed multivariable logistic regression models
- Generated reproducible analytical outputs
- Produced publication-ready visualizations

---

## Public Demonstration Dataset

The public repository uses **500 fully synthetic leptospirosis surveillance records** created to reproduce the structure of the analytical workflow without sharing the original patient-level surveillance data.

Variables include:

- case identifier
- illness-onset year
- age
- sex
- first facility type
- epidemiological investigation documentation
- investigation date documentation
- onset-to-investigation delay
- investigation within 7 days
- laboratory testing
- laboratory result availability
- laboratory positivity
- strict laboratory-confirmation indicator
- final outcome

### Data Privacy

This repository contains **no original patient-level surveillance records**.

No personal identifiers, original health facility records, or confidential source datasets are publicly shared.

---

## Analytical Workflow

1. Import synthetic surveillance data
2. Perform data-quality checks
3. Construct surveillance indicators
4. Summarize annual surveillance performance
5. Describe onset-to-investigation delay
6. Fit multivariable logistic regression models
7. Generate analytical figures
8. Export reproducible outputs

---

## Statistical Analysis

Multivariable logistic regression was used to assess factors associated with:

- documented epidemiological investigation; and
- documented laboratory testing.

Covariates included:

- age;
- sex;
- illness-onset year; and
- first facility type.

Adjusted odds ratios and 95% confidence intervals were calculated.

All numerical results displayed in this public repository are generated from the synthetic demonstration dataset and are intended to demonstrate the analytical workflow. They should not be interpreted as official surveillance estimates from the underlying field dataset.

---

## Key Visualizations

### Surveillance Process Coverage

![Surveillance process coverage](figures/figure1_surveillance_coverage.png)

### Annual Epidemiological Investigation Documentation

![Annual epidemiological investigation documentation](figures/figure2_annual_ei.png)

### Median Onset-to-Investigation Delay

![Median onset-to-investigation delay](figures/figure3_ei_delay.png)

---

## Repository Structure

```text
portfolio_leptospirosis/
├── README.md
├── data/
│   └── synthetic_leptospirosis_surveillance.csv
├── R/
│   └── portfolio_analysis.R
├── figures/
│   ├── figure1_surveillance_coverage.png
│   ├── figure2_annual_ei.png
│   └── figure3_ei_delay.png
└── outputs/
    ├── summary_indicators.csv
    ├── annual_surveillance_indicators.csv
    ├── ei_regression_results.csv
    └── lab_regression_results.csv
```

---

## Tools and Skills

### Technical

- R
- ggplot2
- data validation
- descriptive epidemiology
- logistic regression
- confidence interval estimation
- data visualization
- reproducible analysis

### Public Health

- infectious disease surveillance
- field epidemiology
- surveillance-system assessment
- epidemiological investigation
- laboratory data assessment
- translation of analytical findings into public health insights

---

## How to Run

Open:

```text
R/portfolio_analysis.R
```

Set the working directory to the `R` folder and run the script from top to bottom.

The script reads:

```text
../data/synthetic_leptospirosis_surveillance.csv
```

and automatically generates figures and analytical outputs.

---

## Data Use and Confidentiality

This portfolio is based on real field epidemiology and leptospirosis surveillance work in Bantul District, Indonesia.

To protect confidentiality, the original patient-level surveillance dataset is not publicly shared in this repository. The included dataset is fully synthetic and is provided only to demonstrate the analysis workflow, code structure, regression modelling, and data visualization approach.

Numerical results shown in this GitHub repository are therefore demonstration results from the synthetic dataset and should not be interpreted as official surveillance estimates.

---

## Author

**Nilna Sa'adatar Rohmah**

Field Epidemiology | Infectious Disease Surveillance | Public Health Data Analytics
