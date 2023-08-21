SELECT

SPLIT_PART(transaction_code,'-',1) as "Bank",
REPLACE(REPLACE(online_or_in_person,1,'Online'),2,'In Person'),
TO_CHAR((RIGHT(SPLIT_PART(transaction_date, ' ',1),4) || '-' || RIGHT(LEFT(transaction_date,5),2) || '-' || LEFT(transaction_date,2))::date, 'dy') as date

FROM TIL_PLAYGROUND.PREPPIN_DATA_INPUTS.PD2023_WK01;