create table loan_data(
Borrower_ID	VARCHAR(20),
Age INT,
Gender VARCHAR(10),
Employment_Type VARCHAR(20),
Monthly_Income DECIMAL(12,2),
Num_Dependents INT,
Loan_ID VARCHAR(20),
Loan_Amount	DECIMAL(12, 2),
Loan_Tenure	INT,
Interest_Rate DECIMAL(5, 2),
Loan_Type VARCHAR(20),
Collateral_Value DECIMAL(15, 2),
Outstanding_Loan_Amount	DECIMAL(15, 2),
Monthly_EMI	DECIMAL(10, 2),
Payment_History VARCHAR(20),
Num_Missed_Payments INT,
Days_Past_Due INT,
Recovery_Status VARCHAR(30),
Collection_Attempts INT,
Collection_Method VARCHAR(30),
Legal_Action_Taken VARCHAR(5)
);

--1. Basic Queries

-- View all loan records
SELECT * FROM loan_data;

-- Count the total number of loans in the dataset
SELECT COUNT(*) AS Total_Loans FROM loan_data;

-- List all unique types of loans issued
SELECT DISTINCT Loan_Type FROM loan_data;

-- List top 5 borrowers with highest outstanding loan amount
SELECT Borrower_ID, Outstanding_Loan_Amount 
FROM loan_data 
ORDER BY Outstanding_Loan_Amount DESC 
LIMIT 5;

-- List Bott0m 5 borrowers with lowest outstanding loan amount
SELECT Borrower_ID, Outstanding_Loan_Amount 
FROM loan_data 
ORDER BY Outstanding_Loan_Amount ASC 
LIMIT 5;

 --2. Data Cleaning
SELECT COUNT(*) AS Rows_With_NULLs
FROM loan_data
WHERE 
    Borrower_ID IS NULL OR
    Age IS NULL OR
    Gender IS NULL OR
    Employment_Type IS NULL OR
    Monthly_Income IS NULL OR
    Loan_Type IS NULL OR
    Collateral_Value IS NULL OR
    Outstanding_Loan_Amount IS NULL OR
    Monthly_EMI IS NULL OR
    Payment_History IS NULL OR
    Num_Missed_Payments IS NULL OR
    Days_Past_Due IS NULL OR
    Recovery_Status IS NULL OR
    Collection_Attempts IS NULL OR
    Collection_Method IS NULL OR
    Legal_Action_Taken IS NULL;

--3.Data Aggregation

-- Show borrowers with a monthly income greater than ₹1,00,000
SELECT Borrower_ID, Monthly_Income
FROM loan_data
WHERE Monthly_Income > 200000;

-- Show monthly income for a specific borrower
SELECT Borrower_ID, Monthly_Income
FROM loan_data
WHERE Borrower_ID = 'BRW_303';

-- Find average interest rate for each employment type
SELECT Employment_Type,
AVG(Interest_Rate) AS Avg_Interest_Rate,
AVG(Monthly_EMI) AS Avg_Monthly_EMI
FROM loan_data 
GROUP BY Employment_Type;

-- 4.Exploratory Data Analysis (EDA)
-- Display borrowers who have missed at least one payment
SELECT Borrower_ID, Num_Missed_Payments 
FROM loan_data 
WHERE Num_Missed_Payments > 0;

-- Sort all borrowers by highest monthly EMI
SELECT Borrower_ID, Monthly_EMI 
FROM loan_data 
ORDER BY Monthly_EMI DESC;

--Show all female borrowers with personal loans
SELECT Borrower_ID, Gender, Loan_Type 
FROM loan_data 
WHERE Gender = 'Female' AND Loan_Type = 'Personal';

-- Sum of missed payments by gender
SELECT Gender, SUM(Num_Missed_Payments) AS Total_Missed_Payments
FROM loan_data
GROUP BY Gender;

-- Borrowers with more than 2 dependents
SELECT Borrower_ID, Num_Dependents
FROM loan_data
WHERE Num_Dependents > 2;

-- Borrowers sorted by number of missed payments (highest first)
SELECT Borrower_ID, Num_Missed_Payments
FROM loan_data
ORDER BY Num_Missed_Payments DESC;

--5.Data Analysis and Insights (Loan Performance)

--1.Loans with interest rate above 10%
SELECT Borrower_ID, Interest_Rate
FROM loan_data
WHERE Interest_Rate > 10.00;

--2.Borrowers older than 60
SELECT Borrower_ID, Age
FROM loan_data
WHERE Age > 60;

--3.Loans with collection method as "Settlement Offer"
SELECT Borrower_ID, Collection_Method
FROM loan_data
WHERE Collection_Method = 'Settlement Offer';

--3.Borrowers past due over 30 days
SELECT Borrower_ID, Days_Past_Due
FROM loan_data
WHERE Days_Past_Due > 30;


--4.Loans with collection method as "Settlement Offer"
SELECT Borrower_ID, Collection_Method
FROM loan_data
WHERE Collection_Method = 'Settlement Offer';

--5.Risky loans where collateral is less than loan
SELECT Borrower_ID, Collateral_Value, Loan_Amount
FROM loan_data
WHERE Collateral_Value <= Loan_Amount;

--6.Find loan types with more than 10 borrowers who missed payments
SELECT Loan_Type, COUNT(*) AS Borrower_Count
FROM loan_data
WHERE Num_Missed_Payments > 0
GROUP BY Loan_Type
HAVING COUNT(*) > 10;

--7.Past due loans not fully recovered
SELECT Borrower_ID, Recovery_Status, Days_Past_Due
FROM loan_data
WHERE Recovery_Status != 'Fully Recovered'
  AND Days_Past_Due > 0;

--8.Self-employed borrowers at higher risk
SELECT Borrower_ID, Monthly_Income, Loan_Type
FROM loan_data
WHERE Employment_Type = 'Self-Employed'
  AND Monthly_Income < 50000
  AND Loan_Type = 'Business';

--9.List borrowers whose payment history is NOT On-Time or does not include "On-Time"
SELECT Borrower_ID, Payment_History
FROM loan_data
WHERE Payment_History NOT LIKE '%On-Time%';

--10 List of borrowers with legal action status labeled
SELECT 
    Borrower_ID,
    CASE 
        WHEN Legal_Action_Taken = 'Yes' THEN 'Legal Action Taken'
        WHEN Legal_Action_Taken = 'No' THEN 'No Legal Action'
        ELSE 'Unknown Status'
    END AS Legal_Action_Status
FROM loan_data;



















