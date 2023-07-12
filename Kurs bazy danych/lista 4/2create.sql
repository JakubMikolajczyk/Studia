DROP TABLE if EXISTS SalesLT.PriceHistory
GO
DROP TRIGGER if EXISTS priceTriggerUpdate
GO
DROP TRIGGER if EXISTS priceTriggerInsert
GO

CREATE TABLE SalesLT.PriceHistory(
    ID int FOREIGN KEY REFERENCES SalesLT.Product(productID),
    price MONEY,
    modDate DATETIME
)
GO
INSERT INTO SalesLT.PriceHistory SELECT ProductID, ListPrice, GETDATE() FROM SalesLT.Product
GO

CREATE TRIGGER priceTriggerUpdate ON [SalesLT].Product
AFTER UPDATE AS
BEGIN
    INSERT INTO SalesLT.PriceHistory 
    SELECT inserted.ProductID, inserted.ListPrice, GETDATE() FROM inserted, deleted 
    WHERE inserted.ProductID = deleted.ProductID 
    AND inserted.ListPrice <> deleted.ListPrice
END
GO


CREATE TRIGGER priceTriggerInsert ON [SalesLT].Product
AFTER INSERT AS
BEGIN
    INSERT INTO SalesLT.PriceHistory 
    SELECT ProductID, ListPrice, GETDATE() FROM inserted
END
GO