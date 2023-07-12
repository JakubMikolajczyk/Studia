-- CREATE TABLE [SalesLT].[Customer_Backup] LIKE SalesLT.Customer

-- SELECT * 
-- INTO [SalesLT].[Customer_Backup] 
-- FROM [SalesLT].[Customer] 
-- WHERE 1 = 0;

DELETE FROM [SalesLT].[Customer_Backup]


SET IDENTITY_INSERT SalesLT.Customer_Backup on
INSERT INTO [SalesLT].Customer_Backup (CustomerID, NameStyle, Title, FirstName, MiddleName, LastName, Suffix, CompanyName, SalesPerson, EmailAddress, Phone, PasswordHash, PasswordSalt, rowguid, ModifiedDate, CreditCardNumber)
SELECT CustomerID, NameStyle, Title, FirstName, MiddleName, LastName, Suffix, CompanyName, SalesPerson, EmailAddress, Phone, PasswordHash, PasswordSalt, rowguid, ModifiedDate, CreditCardNumber FROM [SalesLT].[Customer]
SET IDENTITY_INSERT SalesLT.Customer_Backup off
