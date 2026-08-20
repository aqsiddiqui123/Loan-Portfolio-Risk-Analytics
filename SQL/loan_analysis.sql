CREATE DATABASE loan_analytics;
USE loan_analytics;

SET GLOBAL local_infile = 1;
LOAD DATA LOCAL INFILE '/Users/asjadsiddiqui/Downloads/Loan_default.csv'
INTO TABLE Loan_default
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;
SELECT COUNT(*)
FROM loan_analytics;
SHOW tables
USE loan_analytics;

SELECT COUNT(*)
FROM Loan_default;
USE loan_analytics;

SELECT *
FROM Loan_default
LIMIT 10;
SELECT
    'Default',
    COUNT(*) AS loans
FROM Loan_default
GROUP BY 'Default';

SELECT
    SUM(`Default`) AS total_defaults,
    COUNT(*) AS total_loans
FROM Loan_default;
SELECT
    SUM(`Default`) * 100.0 / COUNT(*) AS default_rate_pct
FROM Loan_default;
SELECT
    COUNT(*) AS total_loans,
    ROUND(AVG(LoanAmount), 2) AS avg_loan_amount,
    ROUND(AVG(Income), 2) AS avg_income,
    ROUND(AVG(CreditScore), 2) AS avg_credit_score,
    ROUND(AVG(InterestRate), 2) AS avg_interest_rate,
    ROUND(AVG('Default') * 100, 2) AS default_rate_pct
FROM Loan_default;
SELECT
    CASE
        WHEN CreditScore < 500 THEN 'Below 500'
        WHEN CreditScore < 600 THEN '500-599'
        WHEN CreditScore < 700 THEN '600-699'
        ELSE '700+'
    END AS credit_score_band,

    COUNT(*) AS total_loans,


    SUM(`Default`) * 100.0 / COUNT(*) AS default_rate_pct


FROM Loan_default
GROUP BY credit_score_band
ORDER BY credit_score_band;

SELECT
    MIN(DTIRatio) AS min_dti,
    MAX(DTIRatio) AS max_dti,
    ROUND(AVG(DTIRatio), 2) AS avg_dti
FROM Loan_default;

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
        SUM(`Default`) * 100.0 / COUNT(*),
        2
    ) AS default_rate_pct

FROM Loan_default

GROUP BY dti_band
ORDER BY default_rate_pct DESC;

SELECT
    MIN(Income) AS min_income,
    MAX(Income) AS max_income,
    ROUND(AVG(Income), 2) AS avg_income
FROM Loan_default;

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
        SUM(`Default`) * 100.0 / COUNT(*),
        2
    ) AS default_rate_pct

FROM Loan_default

GROUP BY income_band
ORDER BY default_rate_pct DESC;

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
        SUM(`Default`) * 100.0 / COUNT(*),
        2
    ) AS default_rate_pct

FROM Loan_default

GROUP BY interest_rate_band
ORDER BY default_rate_pct DESC;
    
    SELECT DISTINCT LoanPurpose
FROM Loan_default;
SELECT
    LoanPurpose,
    COUNT(*) AS total_loans,
    ROUND(
        SUM(`Default`) * 100.0 / COUNT(*),
        2
    ) AS default_rate_pct

FROM Loan_default

GROUP BY LoanPurpose
ORDER BY default_rate_pct DESC;

SELECT DISTINCT EmploymentType
FROM Loan_default;
SELECT
    EmploymentType,
    COUNT(*) AS total_loans,
    ROUND(
        SUM(`Default`) * 100.0 / COUNT(*),
        2
    ) AS default_rate_pct

FROM Loan_default

GROUP BY EmploymentType
ORDER BY default_rate_pct DESC;

SELECT
    CASE
        WHEN LoanAmount < 50000 THEN 'Below $50k'
        WHEN LoanAmount < 100000 THEN '$50k-$99k'
        WHEN LoanAmount < 150000 THEN '$100k-$149k'
        ELSE '$150k+'
    END AS loan_amount_band,

    COUNT(*) AS total_loans,

    ROUND(
        SUM(`Default`) * 100.0 / COUNT(*),
        2
    ) AS default_rate_pct

FROM Loan_default

GROUP BY loan_amount_band
ORDER BY default_rate_pct DESC;

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
        SUM(`Default`) * 100.0 / COUNT(*),
        2
    ) AS default_rate_pct

FROM Loan_default

GROUP BY credit_score_band, dti_band

ORDER BY default_rate_pct DESC;
;
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
        SUM(`Default`) * 100.0 / COUNT(*),
        2
    ) AS default_rate_pct

FROM Loan_default

GROUP BY LoanPurpose, credit_score_band

ORDER BY default_rate_pct DESC;

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

SELECT *
FROM loan_analysis_ready
