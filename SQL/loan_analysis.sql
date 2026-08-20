-- ============================================================
-- LOAN PORTFOLIO RISK ANALYTICS
-- MySQL
-- ============================================================

-- ============================================================
-- 1. DATABASE SETUP
-- ============================================================

CREATE DATABASE IF NOT EXISTS loan_analytics;
USE loan_analytics;


-- ============================================================
-- 2. DATA VALIDATION
-- ============================================================

-- Total number of loans
SELECT
    COUNT(*) AS total_loans
FROM Loan_default;


-- Preview dataset
SELECT *
FROM Loan_default
LIMIT 10;


-- Check unique values in Default
SELECT
    `Default`,
    COUNT(*) AS loans
FROM Loan_default
GROUP BY `Default`
ORDER BY `Default`;


-- Check duplicate Loan IDs
SELECT
    LoanID,
    COUNT(*) AS duplicate_count
FROM Loan_default
GROUP BY LoanID
HAVING COUNT(*) > 1;


-- Check missing values in key variables
SELECT
    SUM(CASE WHEN Income IS NULL THEN 1 ELSE 0 END) AS missing_income,
    SUM(CASE WHEN LoanAmount IS NULL THEN 1 ELSE 0 END) AS missing_loan_amount,
    SUM(CASE WHEN CreditScore IS NULL THEN 1 ELSE 0 END) AS missing_credit_score,
    SUM(CASE WHEN InterestRate IS NULL THEN 1 ELSE 0 END) AS missing_interest_rate,
    SUM(CASE WHEN DTIRatio IS NULL THEN 1 ELSE 0 END) AS missing_dti,
    SUM(CASE WHEN `Default` IS NULL THEN 1 ELSE 0 END) AS missing_default
FROM Loan_default;


-- ============================================================
-- 3. PORTFOLIO KPIs
-- ============================================================

SELECT
    COUNT(*) AS total_loans,
    ROUND(SUM(LoanAmount), 2) AS total_loan_amount,
    ROUND(AVG(LoanAmount), 2) AS avg_loan_amount,
    ROUND(AVG(Income), 2) AS avg_income,
    ROUND(AVG(CreditScore), 2) AS avg_credit_score,
    ROUND(AVG(InterestRate), 2) AS avg_interest_rate,
    SUM(`Default`) AS total_defaults,
    ROUND(AVG(`Default`) * 100, 2) AS default_rate_pct
FROM Loan_default;


-- ============================================================
-- 4. CREDIT SCORE ANALYSIS
-- ============================================================

SELECT
    CASE
        WHEN CreditScore < 500 THEN 'Below 500'
        WHEN CreditScore < 600 THEN '500-599'
        WHEN CreditScore < 700 THEN '600-699'
        ELSE '700+'
    END AS credit_score_band,

    COUNT(*) AS total_loans,

    ROUND(
        AVG(`Default`) * 100,
        2
    ) AS default_rate_pct

FROM Loan_default

GROUP BY credit_score_band
ORDER BY default_rate_pct DESC;


-- ============================================================
-- 5. DTI ANALYSIS
-- ============================================================

-- Inspect DTI range
SELECT
    ROUND(MIN(DTIRatio), 3) AS min_dti,
    ROUND(MAX(DTIRatio), 3) AS max_dti,
    ROUND(AVG(DTIRatio), 3) AS avg_dti
FROM Loan_default;


-- Default rate by DTI band
SELECT
    CASE
        WHEN DTIRatio < 0.20 THEN 'Below 20%'
        WHEN DTIRatio < 0.30 THEN '20-29%'
        WHEN DTIRatio < 0.40 THEN '30-39%'
        WHEN DTIRatio < 0.50 THEN '40-49%'
        ELSE '50%+'
    END AS dti_band,

    COUNT(*) AS total_loans,

    ROUND(
        AVG(`Default`) * 100,
        2
    ) AS default_rate_pct

FROM Loan_default

GROUP BY dti_band
ORDER BY default_rate_pct DESC;


-- ============================================================
-- 6. INCOME ANALYSIS
-- ============================================================

-- Income distribution
SELECT
    ROUND(MIN(Income), 2) AS min_income,
    ROUND(MAX(Income), 2) AS max_income,
    ROUND(AVG(Income), 2) AS avg_income
FROM Loan_default;


-- Default rate by income band
SELECT
    CASE
        WHEN Income < 30000 THEN 'Below $30k'
        WHEN Income < 50000 THEN '$30k-$49k'
        WHEN Income < 75000 THEN '$50k-$74k'
        WHEN Income < 100000 THEN '$75k-$99k'
        ELSE '$100k+'
    END AS income_band,

    COUNT(*) AS total_loans,

    ROUND(
        AVG(`Default`) * 100,
        2
    ) AS default_rate_pct

FROM Loan_default

GROUP BY income_band
ORDER BY default_rate_pct DESC;


-- ============================================================
-- 7. INTEREST RATE ANALYSIS
-- ============================================================

SELECT
    CASE
        WHEN InterestRate < 5 THEN 'Below 5%'
        WHEN InterestRate < 10 THEN '5-9%'
        WHEN InterestRate < 15 THEN '10-14%'
        WHEN InterestRate < 20 THEN '15-19%'
        ELSE '20%+'
    END AS interest_rate_band,

    COUNT(*) AS total_loans,

    ROUND(
        AVG(`Default`) * 100,
        2
    ) AS default_rate_pct

FROM Loan_default

GROUP BY interest_rate_band
ORDER BY default_rate_pct DESC;


-- ============================================================
-- 8. LOAN PURPOSE ANALYSIS
-- ============================================================

SELECT
    LoanPurpose,
    COUNT(*) AS total_loans,

    ROUND(
        AVG(`Default`) * 100,
        2
    ) AS default_rate_pct

FROM Loan_default

GROUP BY LoanPurpose
ORDER BY default_rate_pct DESC;


-- ============================================================
-- 9. EMPLOYMENT TYPE ANALYSIS
-- ============================================================

SELECT
    EmploymentType,
    COUNT(*) AS total_loans,

    ROUND(
        AVG(`Default`) * 100,
        2
    ) AS default_rate_pct

FROM Loan_default

GROUP BY EmploymentType
ORDER BY default_rate_pct DESC;


-- ============================================================
-- 10. LOAN AMOUNT ANALYSIS
-- ============================================================

SELECT
    CASE
        WHEN LoanAmount < 50000 THEN 'Below $50k'
        WHEN LoanAmount < 100000 THEN '$50k-$99k'
        WHEN LoanAmount < 150000 THEN '$100k-$149k'
        ELSE '$150k+'
    END AS loan_amount_band,

    COUNT(*) AS total_loans,

    ROUND(
        AVG(`Default`) * 100,
        2
    ) AS default_rate_pct

FROM Loan_default

GROUP BY loan_amount_band
ORDER BY default_rate_pct DESC;


-- ============================================================
-- 11. CREDIT SCORE × DTI RISK SEGMENTATION
-- ============================================================

SELECT
    CASE
        WHEN CreditScore < 500 THEN 'Below 500'
        WHEN CreditScore < 600 THEN '500-599'
        WHEN CreditScore < 700 THEN '600-699'
        ELSE '700+'
    END AS credit_score_band,

    CASE
        WHEN DTIRatio < 0.30 THEN 'Low DTI'
        WHEN DTIRatio < 0.50 THEN 'Medium DTI'
        ELSE 'High DTI'
    END AS dti_band,

    COUNT(*) AS total_loans,

    ROUND(
        AVG(`Default`) * 100,
        2
    ) AS default_rate_pct

FROM Loan_default

GROUP BY
    credit_score_band,
    dti_band

ORDER BY default_rate_pct DESC;


-- ============================================================
-- 12. LOAN PURPOSE × CREDIT SCORE SEGMENTATION
-- ============================================================

SELECT
    LoanPurpose,

    CASE
        WHEN CreditScore < 500 THEN 'Below 500'
        WHEN CreditScore < 600 THEN '500-599'
        WHEN CreditScore < 700 THEN '600-699'
        ELSE '700+'
    END AS credit_score_band,

    COUNT(*) AS total_loans,

    ROUND(
        AVG(`Default`) * 100,
        2
    ) AS default_rate_pct

FROM Loan_default

GROUP BY
    LoanPurpose,
    credit_score_band

ORDER BY default_rate_pct DESC;


-- ============================================================
-- 13. CREATE ANALYSIS-READY TABLE FOR PYTHON
-- ============================================================

DROP TABLE IF EXISTS loan_analysis_ready;

CREATE TABLE loan_analysis_ready AS

SELECT
    LoanID,
    Age,
    Income,
    LoanAmount,
    CreditScore,
    MonthsEmployed,
    NumCreditLines,
    InterestRate,
    LoanTerm,
    DTIRatio,
    Education,
    EmploymentType,
    MaritalStatus,
    HasMortgage,
    HasDependents,
    LoanPurpose,
    HasCoSigner,
    `Default`,

    CASE
        WHEN CreditScore < 500 THEN 'Below 500'
        WHEN CreditScore < 600 THEN '500-599'
        WHEN CreditScore < 700 THEN '600-699'
        ELSE '700+'
    END AS credit_score_band,

    CASE
        WHEN DTIRatio < 0.30 THEN 'Low DTI'
        WHEN DTIRatio < 0.50 THEN 'Medium DTI'
        ELSE 'High DTI'
    END AS dti_band

FROM Loan_default;


-- ============================================================
-- 14. VERIFY ANALYSIS-READY TABLE
-- ============================================================

SELECT
    COUNT(*) AS analysis_ready_rows
FROM loan_analysis_ready;


SELECT *
FROM loan_analysis_ready
LIMIT 10;
