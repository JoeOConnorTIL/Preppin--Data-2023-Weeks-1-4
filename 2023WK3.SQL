--Requirements
--Input the data
--For the transactions file:
--Filter the transactions to just look at DSB 
--These will be transactions that contain DSB in the Transaction Code field
--Rename the values in the Online or In-person field, Online of the 1 values and In-Person for the 2 values
--Change the date to be the quarter 
--Sum the transaction values for each quarter and for each Type of Transaction (Online or In-Person) 
--For the targets file:
--Pivot the quarterly targets so we have a row for each Type of Transaction and each Quarter 
--Rename the fields
--Remove the 'Q' from the quarter field and make the data type numeric 
--Join the two datasets together 
--You may need more than one join clause!
--Remove unnecessary fields
--Calculate the Variance to Target for each row
--Output the data
--Inputs for reference
SELECT 
  * 
FROM 
  PD2023_WK01;
SELECT 
  * 
FROM 
  PD2023_WK03_TARGETS;
--SOLUTION
WITH BASE AS (
  SELECT 
    SPLIT_PART(TRANSACTION_CODE, '-', 1) AS CODE, 
    CASE WHEN ONLINE_OR_IN_PERSON = 1 THEN 'Online' ELSE 'In-Person' END AS ONLINE_OR_IN_PERSON, 
    QUARTER(
      DATE(
        TRANSACTION_DATE, 'dd/MM/yyyy hh24:mi:ss'
      )
    ) AS QUARTER_, 
    value 
  FROM 
    PD2023_WK01 
  WHERE 
    CODE = 'DSB'
), 
TARGETS AS (
  SELECT 
    ONLINE_OR_IN_PERSON, 
    REPLACE(quarter, 'Q', '') AS quarter, 
    target 
  FROM 
    PD2023_WK03_TARGETS UNPIVOT (
      target FOR quarter IN (Q1, Q2, Q3, Q4)
    )
) 
SELECT 
  B.ONLINE_OR_IN_PERSON, 
  B.QUARTER_, 
  SUM(value) AS value, 
  MAX(t.target) AS Quarterly_Target, 
  SUM(VALUE)- MAX(TARGET) AS Variance_to_target 
FROM 
  BASE AS B 
  INNER JOIN TARGETS AS T ON B.ONLINE_OR_IN_PERSON = T.ONLINE_OR_IN_PERSON 
  AND B.QUARTER_ = T.QUARTER 
GROUP BY 
  B.ONLINE_OR_IN_PERSON, 
  B.QUARTER_;
