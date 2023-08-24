WITH ACCOUNT_INFORMATION AS (
SELECT 
VALUE AS ACCOUNT_HOLDER_ID,
ACCOUNT_NUMBER,
ACCOUNT_TYPE,
BALANCE_DATE,
BALANCE
FROM PD2023_WK07_ACCOUNT_INFORMATION,
LATERAL SPLIT_TO_TABLE(account_holder_id,', ')
WHERE ACCOUNT_HOLDER_ID IS NOT NULL
)

, ACCOUNT_HOLDERS AS (
SELECT 
account_holder_id,
'0' || to_varchar(contact_number) AS phone_number,
name,
date_of_birth,
first_line_of_address
FROM PD2023_WK07_ACCOUNT_HOLDERS
)

SELECT 
td.transaction_id,
transaction_date,
value,
account_to,
account_number,
account_type,
balance_date,
balance,
phone_number as contact_number,
name,
date_of_birth,
first_line_of_address
FROM PD2023_WK07_TRANSACTION_DETAIL as td
INNER JOIN PD2023_WK07_TRANSACTION_PATH as tp ON tp.transaction_id=td.transaction_id
INNER JOIN ACCOUNT_INFORMATION as ai ON ai.account_number=tp.account_from
INNER JOIN ACCOUNT_HOLDERS as ah ON ah.account_holder_id=ai.account_holder_id
WHERE CANCELLED_ LIKE 'N'
AND VALUE > 1000
AND ACCOUNT_TYPE NOT LIKE 'Platinum';