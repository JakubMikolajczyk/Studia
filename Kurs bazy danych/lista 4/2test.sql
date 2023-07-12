DROP PROCEDURE if EXISTS selectPriceHistory
GO
CREATE PROCEDURE selectPriceHistory AS
BEGIN     
    DECLARE @result TABLE(productID int, price MONEY, startDate DATETIME, endDate DATETIME)
    DECLARE iter CURSOR FOR SELECT * FROM SalesLT.PriceHistory ORDER BY ID, modDate DESC
    OPEN iter
    DECLARE @prevID INT, @ID INT, @prevDate DATETIME, @date DATETIME, @price MONEY

    FETCH FROM iter INTO @ID, @price, @date
    SET @prevID = -1
    WHILE (@@fetch_status=0)
    BEGIN
        IF (@prevID = @ID)
            INSERT INTO @result VALUES(@ID, @price, @date, @prevDate)
        ELSE
            INSERT INTO @result VALUES(@ID, @price, @date, NULL)
        
        SET @prevID = @ID
        SET @prevDate = @date
        FETCH FROM iter INTO @ID, @price, @date
    END
    DEALLOCATE iter
    SELECT TOP 20 * FROM @result
END
GO
EXEC selectPriceHistory
-- GO
-- UPDATE [SalesLT].Product
-- SET ListPrice = 125
-- WHERE ProductID < 710
