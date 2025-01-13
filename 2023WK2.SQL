--Requirements
--Input the data
--In the Transactions table, there is a Sort Code field which contains dashes. We need to remove these so just have a 6 digit string
--Use the SWIFT Bank Code lookup table to bring in additional information about the SWIFT code and Check Digits of the receiving bank account
--Add a field for the Country Code
--Hint: all these transactions take place in the UK so the Country Code should be GB
--Create the IBAN as above
--Hint: watch out for trying to combine sting fields with numeric fields - check data types
--Remove unnecessary fields
--Output the data
WITH SWIFT_CODES AS (
  SELECT 
    * 
  FROM 
    PD2023_WK02_SWIFT_CODES
), 
TRANSACTIONS_ AS (
  SELECT 
    * 
  FROM 
    PD2023_WK02_TRANSACTIONS
) 
SELECT 
  TRANSACTION_ID, 
  CONCAT(
    'GB', 
    CHECK_DIGITS, 
    SWIFT_CODE, 
    REPLACE(SORT_CODE, '-', ''), 
    ACCOUNT_NUMBER
  ) AS IBAN 
FROM 
  TRANSACTIONS_ T 
  INNER JOIN SWIFT_CODES S ON s.bank = t.bank
