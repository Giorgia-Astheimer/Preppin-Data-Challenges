SELECT 
'GB' || sc.check_digits || sc.swift_code || replace(sort_code,'-','') || t.account_number as IBAN
FROM PD2023_WK02_TRANSACTIONS AS t
INNER JOIN PD2023_WK02_SWIFT_CODES as sc ON sc.bank=t.bank;