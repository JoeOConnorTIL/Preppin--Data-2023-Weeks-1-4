--Requirements
--Input the data
--Split the Transaction Code to extract the letters at the start of the transaction code. These identify the bank who processes the transaction
--Rename the new field with the Bank code 'Bank'. 
--Rename the values in the Online or In-person field, Online of the 1 values and In-Person for the 2 values. 
--Change the date to be the day of the week
--Different levels of detail are required in the outputs. You will need to sum up the values of the transactions in three ways:
--1. Total Values of Transactions by each bank
--2. Total Values by Bank, Day of the Week and Type of Transaction (Online or In-Person)
--3. Total Values by Bank and Customer Code
--Output each data file

-- Main Prep
SELECT 
  *, 
  SPLIT_PART(TRANSACTION_CODE, '-', 1) AS BANK, 
  CASE WHEN ONLINE_OR_IN_PERSON = 1 THEN 'Online' ELSE 'In-Person' END AS ONLINE_OR_IN_PERSON1, 
  DAYNAME(
    DATE(
      TRANSACTION_DATE, 'dd/MM/yyyy hh24:mi:ss'
    )
  ) AS DAY_ 
FROM 
  PD2023_WK01;
-- Output 1: Total Values of Transactions by Each Bank
SELECT 
  SPLIT_PART(TRANSACTION_CODE, '-', 1) AS BANK, 
  SUM(VALUE) AS VALUE 
FROM 
  PD2023_WK01 
GROUP BY 
  BANK;
-- Output 2: Total Values by Bank, Day of the Week and Type of Transaction (Online or In-Person)
WITH MAIN AS (
  SELECT 
    *, 
    SPLIT_PART(TRANSACTION_CODE, '-', 1) AS BANK, 
    CASE WHEN ONLINE_OR_IN_PERSON = 1 THEN 'Online' ELSE 'In-Person' END AS ONLINE_OR_IN_PERSON1, 
    DAYNAME(
      DATE(
        TRANSACTION_DATE, 'dd/MM/yyyy hh24:mi:ss'
      )
    ) AS DAY_ 
  FROM 
    PD2023_WK01
) 
SELECT 
  BANK, 
  ONLINE_OR_IN_PERSON1, 
  DAY_ AS Transaction_Date, 
  SUM(VALUE) 
FROM 
  MAIN 
GROUP BY 
  BANK, 
  ONLINE_OR_IN_PERSON1, 
  DAY_;
-- Output 3: Total Values by Bank and Customer Code
SELECT 
  SPLIT_PART(TRANSACTION_CODE, '-', 1) AS BANK, 
  customer_code, 
  SUM(VALUE) 
FROM 
  PD2023_WK01 
GROUP BY 
  BANK, 
  CUSTOMER_CODE;