DROP TABLE IF EXISTS Prices
DROP TABLE IF EXISTS Products
DROP TABLE IF EXISTS Rates

CREATE TABLE Products(
    ID int PRIMARY KEY,
    ProductName CHAR(20))

INSERT INTO Products VALUES(1, 'fdgdf')
INSERT INTO Products VALUES(2, 'ghf')
INSERT INTO Products VALUES(3, 'wa')
INSERT INTO Products VALUES(4, 'fgd')



CREATE TABLE Rates(
    Currency CHAR(3) PRIMARY KEY,
    PricePLN MONEY)

INSERT INTO Rates VALUES('PLN', 1)
INSERT INTO Rates VALUES('EUR', 4.68)
INSERT INTO Rates VALUES('USD', 4.32)



CREATE TABLE Prices(
    ProductID int FOREIGN KEY REFERENCES Products(ID),
    Currency CHAR(3) FOREIGN KEY REFERENCES Rates(Currency),
    Price MONEY,
)
x
INSERT INTO Prices VALUES(1, 'PLN', 100)
INSERT INTO Prices VALUES(2, 'PLN', 15)
INSERT INTO Prices VALUES(3, 'PLN', 76)
INSERT INTO Prices VALUES(3, 'USD', 76)
INSERT INTO Prices VALUES(4, 'PLN', 10)


DELETE FROM Prices WHERE Currency != 'PLN'

DECLARE pricesCursor CURSOR FOR SELECT ProductID, Price FROM Prices WHERE Currency = 'PLN'
DECLARE ratesCursor CURSOR FOR SELECT * FROM Rates

DECLARE @productID INT
DECLARE @price MONEY

OPEN pricesCursor
FETCH NEXT FROM pricesCursor INTO @productID, @price

WHILE(@@FETCH_STATUS = 0)
    BEGIN
    DECLARE @currencyRates CHAR(3)
    DECLARE @PricePLN MONEY

    OPEN ratesCursor
    FETCH NEXT FROM ratesCursor INTO @currencyRates, @PricePLN

    WHILE(@@FETCH_STATUS = 0)
        BEGIN
            IF(@currencyRates != 'PLN')
                BEGIN
                    INSERT INTO Prices VALUES(@productID, @currencyRates, @price/@PricePLN)
                END

        FETCH NEXT FROM ratesCursor INTO @currencyRates, @PricePLN
        END
    CLOSE ratesCursor
    FETCH NEXT FROM pricesCursor INTO @productID, @price
    
END
DEALLOCATE pricesCursor
DEALLOCATE ratesCursor

SELECT * FROM Prices