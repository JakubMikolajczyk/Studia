DELETE FROM [SalesLT].[Customer_Backup]

DECLARE @CustomerID INT;
DECLARE @NameStyle BIT;
DECLARE @Title   NVARCHAR(8);
DECLARE @FirstName   dbo.NAME;
DECLARE @MiddleName  dbo.NAME;
DECLARE @LastName    dbo.NAME;
DECLARE @Suffix  NVARCHAR(10);
DECLARE @CompanyName NVARCHAR(128);
DECLARE @SalesPerson NVARCHAR(256);
DECLARE @EmailAddress    NVARCHAR(50);
DECLARE @Phone   dbo.Phone;
DECLARE @PasswordHash    VARCHAR(128);
DECLARE @PasswordSalt    VARCHAR(10);
DECLARE @rowguid     UNIQUEIDENTIFIER;
DECLARE @ModifiedDate    DATETIME;
DECLARE @CreditCardNumber    VARCHAR(20);

SET IDENTITY_INSERT SalesLT.Customer_Backup on
DECLARE iter CURSOR FOR SELECT * FROM [SalesLT].[Customer]


OPEN iter
FETCH NEXT FROM iter INTO @CustomerID, @NameStyle, @Title, @FirstName, @MiddleName, @LastName, @Suffix, @CompanyName, @SalesPerson, @EmailAddress, @Phone, @PasswordHash, @PasswordSalt, @rowguid, @ModifiedDate, @CreditCardNumber

INSERT INTO [SalesLT].Customer_Backup (CustomerID, NameStyle, Title, FirstName, MiddleName, LastName, Suffix, CompanyName, SalesPerson, EmailAddress, Phone, PasswordHash, PasswordSalt, rowguid, ModifiedDate, CreditCardNumber)
VALUES (@CustomerID, @NameStyle, @Title, @FirstName, @MiddleName, @LastName, @Suffix, @CompanyName, @SalesPerson, @EmailAddress, @Phone, @PasswordHash, @PasswordSalt, @rowguid, @ModifiedDate, @CreditCardNumber)

WHILE @@FETCH_STATUS = 0
BEGIN
    FETCH NEXT FROM iter INTO @CustomerID, @NameStyle, @Title, @FirstName, @MiddleName, @LastName, @Suffix, @CompanyName, @SalesPerson, @EmailAddress, @Phone, @PasswordHash, @PasswordSalt, @rowguid, @ModifiedDate, @CreditCardNumber 
    INSERT INTO [SalesLT].Customer_Backup (CustomerID, NameStyle, Title, FirstName, MiddleName, LastName, Suffix, CompanyName, SalesPerson, EmailAddress, Phone, PasswordHash, PasswordSalt, rowguid, ModifiedDate, CreditCardNumber)
    VALUES (@CustomerID, @NameStyle, @Title, @FirstName, @MiddleName, @LastName, @Suffix, @CompanyName, @SalesPerson, @EmailAddress, @Phone, @PasswordHash, @PasswordSalt, @rowguid, @ModifiedDate, @CreditCardNumber)
END

SET IDENTITY_INSERT SalesLT.Customer_Backup off

DEALLOCATE iter