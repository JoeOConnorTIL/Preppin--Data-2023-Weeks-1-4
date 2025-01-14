--Input the data
--We want to stack the tables on top of one another, since they have the same fields in each sheet. We can do this one of 2 ways (help):
--Drag each table into the canvas and use a union step to stack them on top of one another
--Use a wildcard union in the input step of one of the tables
--Some of the fields aren't matching up as we'd expect, due to differences in spelling. Merge these fields together
--Make a Joining Date field based on the Joining Day, Table Names and the year 2023
--Now we want to reshape our data so we have a field for each demographic, for each new customer (help)
--Make sure all the data types are correct for each field
--Remove duplicates (help)
--If a customer appears multiple times take their earliest joining date
--Output the data
WITH MAIN AS (
  SELECT 
    *, 
    'January' AS tablename 
  FROM 
    PD2023_WK04_JANUARY 
  UNION ALL 
  SELECT 
    *, 
    'February' AS tablename 
  FROM 
    PD2023_WK04_FEBRUARY 
  UNION ALL 
  SELECT 
    *, 
    'March' AS tablename 
  FROM 
    PD2023_WK04_MARCH 
  UNION ALL 
  SELECT 
    *, 
    'April' AS tablename 
  FROM 
    PD2023_WK04_APRIL 
  UNION ALL 
  SELECT 
    *, 
    'May' AS tablename 
  FROM 
    PD2023_WK04_MAY 
  UNION ALL 
  SELECT 
    *, 
    'June' AS tablename 
  FROM 
    PD2023_WK04_JUNE 
  UNION ALL 
  SELECT 
    *, 
    'July' AS tablename 
  FROM 
    PD2023_WK04_JULY 
  UNION ALL 
  SELECT 
    *, 
    'August' AS tablename 
  FROM 
    PD2023_WK04_AUGUST 
  UNION ALL 
  SELECT 
    *, 
    'September' AS tablename 
  FROM 
    PD2023_WK04_SEPTEMBER 
  UNION ALL 
  SELECT 
    *, 
    'October' AS tablename 
  FROM 
    PD2023_WK04_OCTOBER 
  UNION ALL 
  SELECT 
    *, 
    'November' AS tablename 
  FROM 
    PD2023_WK04_NOVEMBER 
  UNION ALL 
  SELECT 
    *, 
    'December' AS tablename 
  FROM 
    PD2023_WK04_DECEMBER
), 
PRE_PIVOT AS (
  SELECT 
    ID, 
    DATE_FROM_PARTS(
      '2023', CASE WHEN tablename = 'January' then 01 WHEN tablename = 'February' then 02 WHEN tablename = 'March' then 03 WHEN tablename = 'April' then 04 WHEN tablename = 'May' then 05 WHEN tablename = 'June' then 06 WHEN tablename = 'July' then 07 WHEN tablename = 'August' then 08 WHEN tablename = 'September' then 09 WHEN tablename = 'October' then 10 WHEN tablename = 'November' then 11 WHEN tablename = 'December' then 12 END, 
      JOINING_DAY
    ) AS JOINING_DATE, 
    demographic, 
    value 
  FROM 
    MAIN
), 
POST_PIVOT AS (
  SELECT 
    id, 
    joining_date, 
    ethnicity, 
    account_type, 
    date_of_birth :: date, 
    ROW_NUMBER() OVER(
      PARTITION BY id 
      ORDER BY 
        joining_date ASC
    ) as rn 
  FROM 
    PRE_PIVOT PIVOT(
      MAX(value) for demographic IN (
        'Ethnicity', 'Account Type', 'Date of Birth'
      )
    ) as P (
      id, joining_date, ethnicity, account_type, 
      date_of_birth
    )
) 
SELECT 
  * 
FROM 
  POST_PIVOT 
WHERE 
  rn = 1
