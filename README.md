# Loan-Portfolio-Risk-Analytics
Loan portfolio default-risk analysis using SQL, Python, statistical testing, and credit-risk segmentation.
Overview

This project analyzes borrower- and loan-level characteristics to identify segments associated with elevated default risk and translate those findings into targeted portfolio-risk recommendations.

The workflow combines MySQL for data preparation and segmentation with Python for deeper risk analysis, multivariate borrower profiling, statistical hypothesis testing, and visualization.

The project is designed as a portfolio-level credit-risk analysis rather than a production lending model.

Business Objective

The analysis focuses on four questions:

Which borrower characteristics are associated with higher observed default rates?
Which loan products and employment groups appear riskier?
Which combinations of borrower characteristics create the highest-risk segments?
How should a lender prioritize underwriting review and portfolio monitoring based on these findings?
Tools Used
MySQL
Python
pandas
NumPy
SciPy
statsmodels
Matplotlib
Jupyter / Anaconda
Dataset

The project uses the Loan Default Prediction Dataset from Kaggle.

The dataset contains borrower- and loan-level variables including:

Age
Income
LoanAmount
CreditScore
MonthsEmployed
NumCreditLines
InterestRate
LoanTerm
DTIRatio
Education
EmploymentType
MaritalStatus
HasMortgage
HasDependents
LoanPurpose
HasCoSigner
Default

Default is a binary outcome:

1 = borrower defaulted
0 = borrower did not default

The raw dataset is not redistributed in this repository. It can be downloaded from the original Kaggle source.

Project Workflow
Raw Loan Data
      ↓
MySQL Import
      ↓
Data Validation
      ↓
Portfolio KPI Analysis
      ↓
Borrower Segmentation
      ↓
Analysis-Ready SQL Table
      ↓
Python Risk Analysis
      ↓
Multivariate Risk Segmentation
      ↓
Statistical Hypothesis Testing
      ↓
Visualizations
      ↓
Risk Management Recommendations
SQL Analysis

MySQL was used to prepare and investigate the loan portfolio.

Data Validation

The SQL analysis included:

Loan count validation
Duplicate LoanID checks
Missing-value checks
Default distribution checks
Review of borrower and loan-variable ranges
Portfolio KPIs

The following portfolio-level metrics were calculated:

Total number of loans
Total loan amount
Average loan amount
Average borrower income
Average credit score
Average interest rate
Total number of defaults
Overall default rate
Borrower Segmentation

Default rates were compared across:

Credit-score bands
Debt-to-income bands
Income bands
Interest-rate bands
Loan-amount bands
Loan purpose
Employment type
Multi-Factor Segmentation

The analysis also evaluated combinations such as:

Credit score × DTI
Loan purpose × credit score

An analysis-ready table was then created in SQL for downstream Python analysis.

Python Analysis

Python was used to extend the descriptive SQL analysis and evaluate borrower risk at a more granular level.

Portfolio Summary

Portfolio summary tables were created using pandas to review:

Loan count
Average loan amount
Average borrower income
Average credit score
Average interest rate
Portfolio default rate
Credit Score Analysis

Borrowers were segmented into credit-score bands and compared using:

Number of loans
Average loan amount
Default rate

The observed default rate was highest among borrowers with credit scores below 500.

DTI Analysis

Borrowers were also segmented by debt-to-income ratio.

The analysis compared loan volume, average loan size, and default rates across low-, medium-, and high-DTI borrowers.

Loan Purpose Analysis

Default rates were compared across loan-purpose categories to identify products associated with elevated observed credit risk.

The Other loan-purpose category showed the highest observed purpose-level default rate in the analyzed sample.

Employment Analysis

Borrowers were compared across employment groups.

Part-time borrowers recorded the highest observed employment-group default rate in the sample.

Multivariate Risk Analysis

A credit-score × DTI risk matrix was created using a pandas pivot table:

risk_matrix = pd.pivot_table(
    df,
    values="Default",
    index="credit_score_band",
    columns="dti_band",
    aggfunc="mean"
) * 100

This allows borrower credit quality and leverage to be evaluated jointly instead of independently.

A rule-based high-risk segment was also defined using NumPy:

df["high_risk_flag"] = np.where(
    (df["CreditScore"] < 600) &
    (df["DTIRatio"] > 0.50),
    1,
    0
)

The high-risk group recorded a materially higher observed default rate than the remainder of the portfolio.

Combined Risk Segmentation

The analysis also combined:

Credit Score
      ×
DTI
      ×
Loan Purpose

to identify borrower-product combinations associated with the highest observed default rates.

Among segments with sufficient sample size, the highest observed default rates included:

Below-500 credit + High DTI + Education
Below-500 credit + High DTI + Auto
Below-500 credit + High DTI + Other

This suggests that portfolio risk is more informative when multiple borrower and product characteristics are considered jointly.

Correlation Analysis

Pearson correlations were calculated across numeric borrower and loan variables.

The analysis evaluated relationships between default and variables including:

Age
Income
LoanAmount
CreditScore
MonthsEmployed
NumCreditLines
InterestRate
LoanTerm
DTIRatio

Correlation was used only as a descriptive measure and was not interpreted as evidence of causality.

Statistical Hypothesis Testing

Because Default is binary, two-proportion z-tests were used to compare observed default rates between selected borrower groups.

Tests included:

Low-credit vs high-credit borrowers
High-DTI vs low-DTI borrowers

The tests evaluated:

H0: Default rates are equal between the two groups

H1: Default rates differ between the two groups

A significance threshold of:

p < 0.05

was used.

In the analyzed sample, the standalone credit-score and DTI comparisons were not statistically significant at the 5% level.

This is important because it suggests that these variables should not be used independently as sufficient justification for broad underwriting restrictions.

Key Findings
The portfolio-wide observed default rate was approximately 11.9%.
Borrowers with credit scores below 500 recorded the highest observed credit-band default rate.
High-DTI borrowers recorded a higher observed default rate than lower-DTI segments.
The Other loan-purpose category recorded the highest observed loan-purpose default rate.
Part-time borrowers recorded the highest observed employment-group default rate.
A rule-based segment combining weak credit quality and high DTI showed a substantially higher observed default rate than the rest of the portfolio.
Multi-factor borrower-product combinations showed stronger risk concentration than single-variable comparisons alone.
Standalone credit-score and DTI differences were not statistically significant at the 5% level in this sample.
Risk Management Recommendation

The analysis supports a targeted portfolio-risk strategy rather than broad underwriting restrictions based on a single borrower characteristic.

Borrowers displaying multiple elevated risk indicators should receive enhanced review, particularly where weak credit quality and high leverage occur within higher-default loan-purpose categories.

Recommended actions include:

Prioritize enhanced affordability and underwriting review for multi-factor high-risk segments.
Monitor credit quality, DTI, employment type, and loan purpose jointly rather than independently.
Avoid applying broad approval restrictions based solely on credit score or DTI where standalone statistical evidence is weak.
Track segment-level default rates over time to identify emerging concentration risk.
Validate high-risk borrower-product combinations on larger samples before incorporating them into formal lending-policy thresholds.

The analysis is intended to support portfolio monitoring and risk prioritization rather than serve as a production credit-scoring framework.

Visualizations

Selected project visualizations are stored in the outputs/ folder.

Examples include:

credit_score_default_rate.png
dti_default_rate.png
loan_purpose_default_rate.png
