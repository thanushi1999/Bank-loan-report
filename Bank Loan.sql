SELECT *
FROM bank_loan;

SELECT COUNT(*)
FROM bank_loan;

ALTER TABLE bank_loan
ADD COLUMN con_issue_date DATE;

-- Converting the date values in the 'issue_date' column to a valid date format and adding the values into the column 'con_issue_date'

UPDATE bank_loan
SET con_issue_date = CASE
    WHEN issue_date LIKE '__/__/____' THEN STR_TO_DATE(issue_date, '%d/%m/%Y') -- DD/MM/YYYY
    WHEN issue_date LIKE '__-__-____' THEN STR_TO_DATE(issue_date, '%d-%m-%Y') -- DD-MM-YYYY
    WHEN issue_date LIKE '____-__-__' THEN STR_TO_DATE(issue_date, '%Y-%m-%d') -- YYYY-MM-DD
    ELSE NULL
END;

SET SQL_SAFE_UPDATES = 0;

SELECT *
FROM bank_loan;

ALTER TABLE bank_loan
DROP COLUMN issue_date;

ALTER TABLE bank_loan
CHANGE COLUMN con_issue_date issue_date Date;

-- Adding column as 'con_last_credit_pull_date' to the table

ALTER TABLE bank_loan
ADD COLUMN con_last_credit_pull_date DATE;

UPDATE bank_loan
SET con_last_credit_pull_date = CASE
    WHEN last_credit_pull_date LIKE '__/__/____' THEN STR_TO_DATE(last_credit_pull_date, '%d/%m/%Y') -- DD/MM/YYYY
    WHEN last_credit_pull_date LIKE '__-__-____' THEN STR_TO_DATE(last_credit_pull_date, '%d-%m-%Y') -- DD-MM-YYYY
    WHEN last_credit_pull_date LIKE '____-__-__' THEN STR_TO_DATE(last_credit_pull_date, '%Y-%m-%d') -- YYYY-MM-DD
    ELSE NULL
END;

ALTER TABLE bank_loan
DROP COLUMN last_credit_pull_date;

ALTER TABLE bank_loan
CHANGE COLUMN con_last_credit_pull_date last_credit_pull_date DATE;

-- Repeating the same steps for the 'next_payment_date' column

ALTER TABLE bank_loan
ADD COLUMN con_next_payment_date DATE;

UPDATE bank_loan
SET con_next_payment_date = CASE
    WHEN next_payment_date LIKE '__/__/____' THEN STR_TO_DATE(next_payment_date, '%d/%m/%Y') -- DD/MM/YYYY
    WHEN next_payment_date LIKE '__-__-____' THEN STR_TO_DATE(next_payment_date, '%d-%m-%Y') -- DD-MM-YYYY
    WHEN next_payment_date LIKE '____-__-__' THEN STR_TO_DATE(next_payment_date, '%Y-%m-%d') -- YYYY-MM-DD
    ELSE NULL
END;

ALTER TABLE bank_loan
DROP COLUMN next_payment_date;

ALTER TABLE bank_loan
CHANGE COLUMN con_next_payment_date next_payment_date DATE;

SELECT *
FROM bank_loan

-- last_payment_date

ALTER TABLE bank_loan
ADD COLUMN con_last_payment_date DATE;

UPDATE bank_loan
SET con_last_payment_date = CASE
    WHEN last_payment_date LIKE '__/__/____' THEN STR_TO_DATE(last_payment_date, '%d/%m/%Y') -- DD/MM/YYYY
    WHEN last_payment_date LIKE '__-__-____' THEN STR_TO_DATE(last_payment_date, '%d-%m-%Y') -- DD-MM-YYYY
    WHEN last_payment_date LIKE '____-__-__' THEN STR_TO_DATE(last_payment_date, '%Y-%m-%d') -- YYYY-MM-DD
    ELSE NULL
END;

ALTER TABLE bank_loan
DROP COLUMN last_payment_date;

ALTER TABLE bank_loan
CHANGE COLUMN con_last_payment_date last_payment_date DATE;

SELECT * 
FROM bank_loan

-- Calculating the total applications recieved

SELECT COUNT(id) AS Total_Loan_Applications
FROM bank_loan

-- Calculating MTD Total Loan Applications

SELECT COUNT(id) AS MTD_Total_Loan_Applications
FROM bank_loan WHERE MONTH(issue_date) =12 and YEAR(issue_date) = 2021; -- 4314

-- Calculating PMTD Total Loan Applications

SELECT COUNT(id) AS PMTD_Total_Loan_Applications
FROM bank_loan WHERE MONTH(issue_date) =11 and YEAR(issue_date) = 2021; -- 4035

-- Calculating the MOM Total Loan Applications

WITH MTD_app AS(
SELECT COUNT(id) AS MTD_Total_Loan_Applications
FROM bank_loan WHERE MONTH(issue_date) =12 and YEAR(issue_date) = 2021),
PMTD_app AS (
SELECT COUNT(id) AS PMTD_Total_Loan_Applications
FROM bank_loan WHERE MONTH(issue_date) =11 and YEAR(issue_date) = 2021)

SELECT ((MTD.MTD_Total_Loan_Applications - PMTD.PMTD_Total_Loan_Applications)/PMTD.PMTD_Total_Loan_Applications*100) AS MOM_Total_Loan_Applications
FROM MTD_app MTD, PMTD_app PMTD; -- 6.9%

-- Calculating the total funded amount

SELECT SUM(loan_amount) AS Total_Funded_Amount
FROM bank_loan -- 435757075

-- Calculating the MTD Total Funded Amount 

SELECT SUM(loan_amount) AS MTD_Total_Funded_Amount
FROM bank_loan
WHERE MONTH(issue_date) = 12 AND YEAR(issue_date) = 2021; -- 53981425

-- Calculating the PMTD Total Funded Amount

SELECT SUM(loan_amount) AS PMTD_Total_Funded_Amount
FROM bank_loan
WHERE MONTH(issue_date) = 11 AND YEAR(issue_date) = 2021; -- 47754825

WITH MTD_funded AS (
SELECT SUM(loan_amount) AS MTD_Total_Funded_Amount
FROM bank_loan
WHERE MONTH(issue_date) = 12 AND YEAR(issue_date) = 2021),
PMTD_funded AS (
SELECT SUM(loan_amount) AS PMTD_Total_Funded_Amount
FROM bank_loan
WHERE MONTH(issue_date) = 11 AND YEAR(issue_date) = 2021)

SELECT ((MTD.MTD_Total_Funded_Amount - PMTD.PMTD_Total_Funded_Amount)/PMTD.PMTD_Total_Funded_Amount *100) AS MOM_Total_Funded_Amount
FROM MTD_funded MTD, PMTD_funded PMTD; -- 13%

-- Calculating the Total Amount Recieved

SELECT SUM(total_payment) AS Total_Amount_Recieved
FROM bank_loan

-- Calculating the MTD Total Amount Recieved 

SELECT SUM(total_payment) AS MTD_Total_Amount_Recieved
FROM bank_loan
WHERE MONTH(issue_date) = 12 AND YEAR(issue_date) = 2021;

-- Calculating the PMTD Total Amount Recieved

SELECT SUM(total_payment) AS PMTD_Total_Amount_Recieved
FROM bank_loan
WHERE MONTH(issue_date) = 11 AND YEAR(issue_date) = 2021;

-- Calculating the MOM Total Amount Recieved

WITH MTD_payment AS (
SELECT SUM(total_payment) AS MTD_Total_Amount_Recieved
FROM bank_loan
WHERE MONTH(issue_date) = 12 AND YEAR(issue_date) = 2021),
PMTD_payment AS (
SELECT SUM(total_payment) AS PMTD_Total_Amount_Recieved
FROM bank_loan
WHERE MONTH(issue_date) = 11 AND YEAR(issue_date) = 2021)

SELECT ((MTD.MTD_Total_Amount_Recieved - PMTD.PMTD_Total_Amount_Recieved)/PMTD.PMTD_Total_Amount_Recieved *100) AS MOM_Total_Amount_Recieved
FROM MTD_payment MTD, PMTD_payment PMTD;

-- Calculating the Average Interest rate

SELECT AVG(int_rate)*100 AS Avg_interest_rate FROM bank_loan;

-- Calculating the MTD Avg Int Rate

SELECT AVG(int_rate)*100 AS MTD_Avg_interest_rate FROM bank_loan
WHERE MONTH(issue_date) = 12 AND YEAR(issue_date) = 2021;

-- Calculating the PMTD Avg Int Rate

SELECT AVG(int_rate)*100 AS PMTD_Avg_interest_rate FROM bank_loan
WHERE MONTH(issue_date) = 11 AND YEAR(issue_date) = 2021;

-- Calculating the MOM Avg Int Rate

WITH MTD_avg_int AS (
SELECT AVG(int_rate)*100 AS MTD_Avg_interest_rate FROM bank_loan
WHERE MONTH(issue_date) = 12 AND YEAR(issue_date) = 2021),
PMTD_avg_int AS (
SELECT AVG(int_rate)*100 AS PMTD_Avg_interest_rate FROM bank_loan
WHERE MONTH(issue_date) = 11 AND YEAR(issue_date) = 2021)

SELECT ((MTD.MTD_Avg_interest_rate - PMTD.PMTD_Avg_interest_rate)/PMTD.PMTD_Avg_interest_rate *100) AS MOM_Avg_interest_rate
FROM MTD_avg_int MTD, PMTD_avg_int PMTD;

-- Calculating the Avg Debt To Income Ratio (DTI)

SELECT AVG(dti)*100 AS MTD_Avg_DTI FROM bank_loan;

-- Calculating the MTD DTI

SELECT AVG(dti)*100 AS MTD_Avg_DTI FROM bank_loan
WHERE MONTH(issue_date) = 12 AND YEAR(issue_date) = 2021;

-- Calculating the PMTD DTI

SELECT AVG(dti)*100 AS PMTD_Avg_DTI FROM bank_loan
WHERE MONTH(issue_date) = 11 AND YEAR(issue_date) = 2021;

-- Calculating the MOM DTI

WITH MTD_DTI AS (
SELECT AVG(dti) AS MTD_Avg_DTI
FROM bank_loan
WHERE MONTH(issue_date) = 12 AND YEAR(issue_date) = 2021),
PMTD_DTI AS (
SELECT AVG(dti) AS PMTD_Avg_DTI
FROM bank_loan
WHERE MONTH(issue_date) = 11 AND YEAR(issue_date) = 2021)

SELECT ((MTD.MTD_Avg_DTI - PMTD.PMTD_Avg_DTI)/PMTD.PMTD_Avg_DTI *100) AS MOM_Avg_DTI
FROM MTD_DTI MTD, PMTD_DTI PMTD;

-- Calculating the Good Loan Application Percentage

SELECT (COUNT(CASE WHEN loan_status = 'Fully Paid' OR loan_status = 'Current' THEN id END)*100)/
COUNT(id) AS GOOD_Loan_Percentage
FROM bank_loan;

-- Calculating the Total Good Loan Applications

SELECT COUNT(id) AS Good_Loan_Applications
FROM bank_loan
WHERE loan_status = 'Fully Paid' OR loan_status = 'Current';

-- Calculating the Good Loan Funded Amount

SELECT SUM(loan_amount) AS Good_Loan_Funded_Amount
FROM bank_loan
WHERE loan_status = 'Fully Paid' OR loan_status = 'Current';

-- Calculating the Good Loan Recieved Amount

SELECT SUM(total_payment) AS Good_Loan_Amount_Recieved
FROM bank_loan
WHERE loan_status = 'Fully Paid' OR loan_status = 'Current';

-- Bad Loan Issued
-- Calculating Bad Loan Percentage

SELECT (COUNT(CASE WHEN loan_status = 'Charged off' THEN id END)*100)/
COUNT(id) AS Bad_Loan_Percentage
FROM bank_loan;

-- Calculating the total count of Bad Loan Applications

SELECT COUNT(id) AS Bad_Loan_Applications
FROM bank_loan
WHERE loan_status = 'Charged off';

-- Calculating the Bad Loan Funded Amount

SELECT SUM(loan_amount) AS Bad_Loan_Funded_Amount
FROM bank_loan
WHERE loan_status = 'Charged off';

-- Calculating the Loan_Count, Total_Amount_Recieved, Total_Funded_Amount, Interest_rate, DTI on the basis of the loan_status 

SELECT 
	loan_status,
    COUNT(id) AS Loan_Count,
    SUM(total_payment) AS Total_Amount_Recieved,
    SUM(loan_amount) AS Total_Funded_Amount,
    AVG(int_rate * 100) AS Interest_Rate,
    AVG(dti * 100) as DTI
FROM
    bank_loan
GROUP BY loan_status;

-- Calculating MTD_Total_Amount_Recieved, MTD_Total_Funded_Amount on the basis of loan_status
-- BANK LOAN REPORT | OVERVIEW - MONTH
SELECT 
    loan_status,
    SUM(total_payment) AS MTD_Total_Amount_Recieved,
    SUM(loan_amount) AS MTD_Total_Funded_Amount
FROM
    bank_loan
WHERE MONTH(issue_date) = 12 AND YEAR(issue_date) = 2021
GROUP BY loan_status;

-- Calculating monthly Total_Loan_Applications, Total_Funded_Amount and Total_Amount_Recieved

SELECT 
    MONTH(issue_date) AS Month_Number,
    MONTHNAME(issue_date) AS Month_Name,
    COUNT(id) AS Total_Loan_Applications,
    SUM(Loan_Amount) AS Total_Funded_Amount,
    SUM(total_payment) AS Total_Amount_Recieved
FROM bank_loan
GROUP BY MONTH(issue_date) , MONTHNAME(issue_date)
ORDER BY MONTH(issue_date);

-- BANK LOAN REPORT | OVERVIEW - STATE

SELECT 
    address_state AS State,
    COUNT(id) AS Total_Loan_Applications,
    SUM(Loan_Amount) AS Total_Funded_Amount,
    SUM(total_payment) AS Total_Amount_Recieved
FROM bank_loan
GROUP BY address_state
ORDER BY address_state;

-- BANK LOAN REPORT | OVERVIEW - TERM

SELECT 
    term AS Term,
    COUNT(id) AS Total_Loan_Applications,
    SUM(Loan_Amount) AS Total_Funded_Amount,
    SUM(total_payment) AS Total_Amount_Recieved
FROM bank_loan
GROUP BY term
ORDER BY term;

-- BANK LOAN REPORT | OVERVIEW - EMPLOYEE LENGTH

SELECT 
    emp_length AS Employee_length,
    COUNT(id) AS Total_Loan_Applications,
    SUM(Loan_Amount) AS Total_Funded_Amount,
    SUM(total_payment) AS Total_Amount_Recieved
FROM bank_loan
GROUP BY emp_length
ORDER BY emp_length;

-- BANK LOAN REPORT | OVERVIEW - PURPOSE

SELECT 
    purpose AS Purpose_Of_Loan,
    COUNT(id) AS Total_Loan_Applications,
    SUM(Loan_Amount) AS Total_Funded_Amount,
    SUM(total_payment) AS Total_Amount_Recieved
FROM bank_loan
GROUP BY purpose
ORDER BY purpose;

-- BANK LOAN REPORT | OVERVIEW - HOME OWNERSHIP

SELECT 
    home_ownership AS HOME_OWNERSHIP,
    COUNT(id) AS Total_Loan_Applications,
    SUM(Loan_Amount) AS Total_Funded_Amount,
    SUM(total_payment) AS Total_Amount_Recieved
FROM bank_loan
GROUP BY home_ownership
ORDER BY home_ownership;

SELECT *
FROM bank_loan;