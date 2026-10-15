DROP TRIGGER IF EXISTS dateUpdate
GO

CREATE TRIGGER dateUpdate ON [SalesLT].[Customer]
AFTER UPDATE AS
BEGIN
    UPDATE [SalesLT].Customer
    SET ModifiedDate = GETDATE()
    FROM inserted, SalesLT.Customer
    WHERE inserted.CustomerID = Customer.CustomerID
END
GO

UPDATE SalesLT.Customer
SET Customer.FirstName = 'test'
WHERE Customer.CustomerID < 10
