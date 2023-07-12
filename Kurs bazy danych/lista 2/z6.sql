DROP PROCEDURE IF EXISTS z6
GO

DROP TYPE IF EXISTS ToUpdate
GO

CREATE TYPE ToUpdate AS TABLE(ProductID INT PRIMARY KEY)
GO

CREATE PROCEDURE z6 @inputTable ToUpdate READONLY, @disDate DATE AS
BEGIN

	SELECT Product.ProductID, DiscontinuedDate
	INTO #temp
	FROM [SalesLT].Product, @inputTable as input
	WHERE
    input.ProductID = Product.ProductID 
	AND Product.DiscontinuedDate is NOT NULL

	Declare @Id int
	While (Select Count(*) From #Temp) > 0
Begin

	DECLARE @date Date
    Select Top 1 @Id = ProductID, @date = DiscontinuedDate From #Temp

    print 'Index: ' + CAST(@Id AS CHAR) + 'has DiscontinuedDate: ' + CAST(@date as CHAR)
    Delete #Temp Where ProductID = @Id

	End

    UPDATE
    [SalesLT].Product
    SET
    Product.DiscontinuedDate = @disDate
    FROM @inputTable as input
    WHERE
    input.ProductID = Product.ProductID 
	AND Product.DiscontinuedDate is NULL
END
GO

DECLARE @toUpdate ToUpdate

INSERT INTO @toUpdate Values(680)
INSERT INTO @toUpdate Values(706)


EXEC z6 @inputTable = @toUpdate, @disDate = '2000-02-15'

SELECT * FROM [SalesLT].[Product]