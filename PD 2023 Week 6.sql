WITH CTE AS (
SELECT * 
FROM PD2023_WK06_DSB_CUSTOMER_SURVEY
UNPIVOT (rating FOR functionality IN
(MOBILE_APP___EASE_OF_USE, MOBILE_APP___EASE_OF_ACCESS, MOBILE_APP___NAVIGATION, MOBILE_APP___LIKELIHOOD_TO_RECOMMEND, 
MOBILE_APP___OVERALL_RATING, ONLINE_INTERFACE___EASE_OF_USE, ONLINE_INTERFACE___EASE_OF_ACCESS, ONLINE_INTERFACE___NAVIGATION, ONLINE_INTERFACE___LIKELIHOOD_TO_RECOMMEND, 
ONLINE_INTERFACE___OVERALL_RATING)
)
)

, PRE_PIVOT AS (
SELECT
split_part(functionality,'___',1) AS platform,
split_part(functionality,'___',-1) AS question_category,
customer_id,
rating
FROM CTE
)

, POST_PIVOT AS (
SELECT *
FROM PRE_PIVOT
PIVOT (MAX(RATING) FOR PLATFORM IN ('MOBILE_APP', 'ONLINE_INTERFACE'))
WHERE QUESTION_CATEGORY NOT LIKE 'OVERALL_RATING'
)

, CATEGORIES AS (
SELECT 
AVG("'MOBILE_APP'") AS avg_mobile,
AVG("'ONLINE_INTERFACE'") AS avg_online,
AVG("'MOBILE_APP'")-AVG("'ONLINE_INTERFACE'") AS difference_ratings,
CASE 
    WHEN AVG("'MOBILE_APP'")-AVG("'ONLINE_INTERFACE'") >=2 THEN 'Mobile App Superfans'
    WHEN AVG("'MOBILE_APP'")-AVG("'ONLINE_INTERFACE'") >=1 THEN 'Mobile App Fans'
    WHEN AVG("'MOBILE_APP'")-AVG("'ONLINE_INTERFACE'") <=-2 THEN 'Online Interface Superfans'
    WHEN AVG("'MOBILE_APP'")-AVG("'ONLINE_INTERFACE'") <=-1 THEN 'Online Interface Fans'
    ELSE 'Neutral'
END as fan_category,
CUSTOMER_ID
FROM POST_PIVOT
GROUP BY CUSTOMER_ID
)

SELECT 
fan_category as preference,
ROUND((COUNT(customer_id) / (SELECT COUNT(customer_id) FROM CATEGORIES))*100,1) AS percent_of_customers
FROM CATEGORIES
GROUP BY fan_category;