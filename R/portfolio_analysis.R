# ============================================================
# LEPTOSPIROSIS SURVEILLANCE ANALYTICS
# Portfolio Project Using Synthetic Data
# ============================================================

# This project uses fully synthetic surveillance data.
# No real patient-level or identifiable information is included.

# Packages
library(ggplot2)
library(gt)

# ------------------------------------------------------------
# 0. CREATE OUTPUT FOLDERS
# ------------------------------------------------------------

dir.create("../figures", recursive = TRUE, showWarnings = FALSE)
dir.create("../outputs", recursive = TRUE, showWarnings = FALSE)

# ------------------------------------------------------------
# 1. IMPORT SYNTHETIC DATA
# ------------------------------------------------------------

lepto <- read.csv(
  "../data/synthetic_leptospirosis_surveillance.csv",
  stringsAsFactors = FALSE
)

stopifnot(nrow(lepto) == 500)

cat("Dataset loaded:", nrow(lepto), "records\n")

# ------------------------------------------------------------
# 2. BASIC DATA CHECKS
# ------------------------------------------------------------

str(lepto)

table(lepto$onset_year)
table(lepto$sex)
table(lepto$first_facility_type)

# ------------------------------------------------------------
# 3. DESCRIPTIVE SURVEILLANCE INDICATORS
# ------------------------------------------------------------

summary_indicators <- data.frame(
  Indicator = c(
    "Reported cases",
    "EI documented",
    "EI within 7 days",
    "Laboratory test documented",
    "Laboratory result available",
    "Laboratory positive",
    "Strict laboratory-confirmed identifiable"
  ),
  n = c(
    nrow(lepto),
    sum(lepto$ei_documented == 1, na.rm = TRUE),
    sum(lepto$ei_within_7_days == TRUE, na.rm = TRUE),
    sum(lepto$lab_test_documented == 1, na.rm = TRUE),
    sum(lepto$lab_result_available == 1, na.rm = TRUE),
    sum(lepto$lab_positive == 1, na.rm = TRUE),
    sum(lepto$strict_lab_confirmed_identifiable == 1, na.rm = TRUE)
  )
)

summary_indicators$Percent <- round(
  100 * summary_indicators$n / nrow(lepto),
  1
)

summary_indicators

# ------------------------------------------------------------
# 4. ANNUAL SURVEILLANCE INDICATORS
# ------------------------------------------------------------

years <- sort(unique(lepto$onset_year))

annual <- do.call(
  rbind,
  lapply(years, function(y) {
    
    d <- lepto[lepto$onset_year == y, ]
    
    delay <- d$onset_to_ei_days[
      !is.na(d$onset_to_ei_days)
    ]
    
    data.frame(
      Year = y,
      Cases = nrow(d),
      
      EI_documented = sum(d$ei_documented == 1, na.rm = TRUE),
      
      EI_percent = round(
        100 * mean(d$ei_documented == 1, na.rm = TRUE),
        1
      ),
      
      Median_delay = if (length(delay) > 0) median(delay) else NA,
      Q1 = if (length(delay) > 0) unname(quantile(delay, 0.25)) else NA,
      Q3 = if (length(delay) > 0) unname(quantile(delay, 0.75)) else NA,
      
      Lab_tested = sum(d$lab_test_documented == 1, na.rm = TRUE),
      
      Lab_percent = round(
        100 * mean(d$lab_test_documented == 1, na.rm = TRUE),
        1
      )
    )
  })
)

annual

# ------------------------------------------------------------
# 5. MULTIVARIABLE MODEL:
# EI DOCUMENTATION
# ------------------------------------------------------------

lepto$age10 <- lepto$age_years / 10

lepto$sex_f <- relevel(
  factor(lepto$sex),
  ref = "Male"
)

lepto$year_f <- relevel(
  factor(lepto$onset_year),
  ref = "2021"
)

lepto$facility_f <- relevel(
  factor(lepto$first_facility_type),
  ref = "Health center"
)

model_ei <- glm(
  ei_documented ~
    age10 +
    sex_f +
    year_f +
    facility_f,
  data = lepto,
  family = binomial
)

summary(model_ei)

s <- summary(model_ei)$coefficients

ei_results <- data.frame(
  Variable = rownames(s),
  aOR = exp(s[, "Estimate"]),
  Lower95 = exp(s[, "Estimate"] - 1.96 * s[, "Std. Error"]),
  Upper95 = exp(s[, "Estimate"] + 1.96 * s[, "Std. Error"]),
  p_value = s[, "Pr(>|z|)"],
  row.names = NULL
)

ei_results <- ei_results[
  ei_results$Variable != "(Intercept)",
]

ei_results[, 2:4] <- round(ei_results[, 2:4], 2)

ei_results

# ------------------------------------------------------------
# 6. MULTIVARIABLE MODEL:
# LABORATORY TESTING
# ------------------------------------------------------------

model_lab <- glm(
  lab_test_documented ~
    age10 +
    sex_f +
    year_f +
    facility_f,
  data = lepto,
  family = binomial
)

summary(model_lab)

s_lab <- summary(model_lab)$coefficients

lab_results <- data.frame(
  Variable = rownames(s_lab),
  aOR = exp(s_lab[, "Estimate"]),
  Lower95 = exp(s_lab[, "Estimate"] - 1.96 * s_lab[, "Std. Error"]),
  Upper95 = exp(s_lab[, "Estimate"] + 1.96 * s_lab[, "Std. Error"]),
  p_value = s_lab[, "Pr(>|z|)"],
  row.names = NULL
)

lab_results <- lab_results[
  lab_results$Variable != "(Intercept)",
]

lab_results[, 2:4] <- round(lab_results[, 2:4], 2)

lab_results

# ------------------------------------------------------------
# 7. FIGURE 1
# SURVEILLANCE PROCESS COVERAGE
# ------------------------------------------------------------

fig1_df <- summary_indicators

fig1_df$Indicator <- factor(
  fig1_df$Indicator,
  levels = rev(fig1_df$Indicator)
)

fig1 <- ggplot(
  fig1_df,
  aes(x = Indicator, y = Percent)
) +
  geom_col(width = 0.7) +
  geom_text(
    aes(label = paste0(n, " (", Percent, "%)")),
    hjust = -0.1
  ) +
  coord_flip() +
  scale_y_continuous(limits = c(0, 110)) +
  labs(
    title = "Synthetic leptospirosis surveillance process coverage",
    subtitle = "Portfolio demonstration dataset",
    x = NULL,
    y = "Percentage of records (%)"
  ) +
  theme_minimal(base_size = 12)

fig1

ggsave(
  "../figures/figure1_surveillance_coverage.png",
  fig1,
  width = 10,
  height = 6,
  dpi = 300
)

# ------------------------------------------------------------
# 8. FIGURE 2
# ANNUAL EI DOCUMENTATION
# ------------------------------------------------------------

fig2 <- ggplot(
  annual,
  aes(
    x = factor(Year),
    y = EI_percent,
    group = 1
  )
) +
  geom_line(linewidth = 1.2) +
  geom_point(size = 3) +
  geom_text(
    aes(label = paste0(EI_percent, "%")),
    vjust = -1
  ) +
  labs(
    title = "Annual epidemiological investigation documentation",
    subtitle = "Synthetic portfolio dataset",
    x = "Year",
    y = "EI documented (%)"
  ) +
  theme_minimal(base_size = 12)

fig2

ggsave(
  "../figures/figure2_annual_ei.png",
  fig2,
  width = 9,
  height = 6,
  dpi = 300
)

# ------------------------------------------------------------
# 9. FIGURE 3
# ONSET-TO-EI DELAY
# ------------------------------------------------------------

fig3 <- ggplot(
  annual,
  aes(
    x = factor(Year),
    y = Median_delay,
    group = 1
  )
) +
  geom_line(linewidth = 1.2) +
  geom_point(size = 3) +
  geom_errorbar(
    aes(ymin = Q1, ymax = Q3),
    width = 0.12
  ) +
  labs(
    title = "Median delay from illness onset to epidemiological investigation",
    subtitle = "Synthetic portfolio dataset",
    x = "Year",
    y = "Median delay (days)"
  ) +
  theme_minimal(base_size = 12)

fig3

ggsave(
  "../figures/figure3_ei_delay.png",
  fig3,
  width = 9,
  height = 6,
  dpi = 300
)

# ------------------------------------------------------------
# 10. EXPORT ANALYTIC RESULTS
# ------------------------------------------------------------

write.csv(
  summary_indicators,
  "../outputs/summary_indicators.csv",
  row.names = FALSE
)

write.csv(
  annual,
  "../outputs/annual_surveillance_indicators.csv",
  row.names = FALSE
)

write.csv(
  ei_results,
  "../outputs/ei_regression_results.csv",
  row.names = FALSE
)

write.csv(
  lab_results,
  "../outputs/lab_regression_results.csv",
  row.names = FALSE
)

# ------------------------------------------------------------
# 11. FINAL CHECK
# ------------------------------------------------------------

cat("\nPortfolio analysis completed.\n")

cat(
  "Synthetic records:",
  nrow(lepto),
  "\n"
)

cat(
  "Figures generated:",
  length(list.files("../figures", pattern = "\\.png$")),
  "\n"
)

cat(
  "Output tables generated:",
  length(list.files("../outputs", pattern = "\\.csv$")),
  "\n"
)

list.files("../figures")
list.files("../outputs")