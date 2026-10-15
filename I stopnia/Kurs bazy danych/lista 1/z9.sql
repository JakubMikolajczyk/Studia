-- ALTER TABLE [SalesLT].[Customer] ADD CreditCardNumber varchar(20) NOT NULL DEFAULT '0000-0000-0000-0000'

-- UPDATE soh
-- SET CreditCardApprovalCode = 1234
-- FROM (
--     SELECT TOP(3) *
--     FROM SalesLT.SalesOrderHeader
--     ORDER BY RAND()
-- ) soh

-- UPDATE Customer
-- SET Customer.CreditCardNumber = 'X' 
-- FROM SalesLT.Customer
--     INNER JOIN SalesLT.SalesOrderHeader
--     ON Customer.CustomerID = SalesOrderHeader.CustomerID
-- WHERE SalesOrderHeader.CreditCardApprovalCode is NOT NULL
