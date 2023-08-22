WITH CTE AS (
SELECT 
*,
'January' as tablename
FROM PD2023_WK04_JANUARY
UNION ALL
SELECT 
*,
'February' as tablename
FROM PD2023_WK04_FEBRUARY
UNION ALL
SELECT 
*,
'March' as tablename
FROM PD2023_WK04_MARCH
UNION ALL
SELECT 
*,
'April' as tablename
FROM PD2023_WK04_APRIL
UNION ALL
SELECT 
*,
'May' as tablename
FROM PD2023_WK04_MAY
UNION ALL
SELECT 
*,
'June' as tablename
FROM PD2023_WK04_JUNE
UNION ALL
SELECT 
*,
'July' as tablename
FROM PD2023_WK04_JULY
UNION ALL
SELECT 
*,
'August' as tablename
FROM PD2023_WK04_AUGUST
UNION ALL
SELECT
*,
'September' as tablename
FROM PD2023_WK04_SEPTEMBER
UNION ALL
SELECT 
*,
'October' as tablename
FROM PD2023_WK04_OCTOBER
UNION ALL
SELECT 
*,
'November' as tablename
FROM PD2023_WK04_NOVEMBER
UNION ALL
SELECT 
*,
'December' as tablename
FROM PD2023_WK04_DECEMBER
)

,CTE2 AS (
SELECT
id,
demographic,
value,
date_from_parts(2023, date_part('month',DATE(tablename,'MMMM')),joining_day) as joining_date
FROM CTE
)

, PIVOT AS (
SELECT 
id,
joining_date,
ethnicity,
account_type,
date_of_birth::date as date_of_birth,
ROW_NUMBER() OVER (PARTITION BY ID ORDER BY JOINING_DATE ASC) AS row_num

FROM CTE2 
PIVOT (MAX(value) FOR demographic IN ('Ethnicity','Account Type','Date of Birth')) AS P
(
id,
joining_date,
ethnicity,
account_type,
date_of_birth)
)

SELECT
id,
joining_date,
ethnicity,
account_type,
date_of_birth
FROM PIVOT
WHERE row_num=1