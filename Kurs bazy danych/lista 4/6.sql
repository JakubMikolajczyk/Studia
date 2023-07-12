DROP TABLE IF EXISTS Cache
DROP TABLE IF EXISTS History
DROP TABLE IF EXISTS Parameters
GO

CREATE TABLE Cache(ID INT IDENTITY PRIMARY KEY, UrlAddress CHAR(30), LastAccess DATETIME)
CREATE TABLE History(ID INT IDENTITY PRIMARY KEY, UrlAddress CHAR(30), LastAccess DATETIME)
CREATE TABLE Parameters(Name CHAR(30), Value INT)
GO

DROP TRIGGER IF EXISTS moveToHistory
GO

CREATE TRIGGER moveToHistory ON Cache
INSTEAD OF INSERT AS
BEGIN
    DECLARE @UrlAddress CHAR(30)
    SELECT @UrlAddress = UrlAddress FROM inserted
    IF EXISTS (SELECT 1 FROM Cache WHERE @UrlAddress=UrlAddress)
        UPDATE Cache SET LastAccess = GETDATE() WHERE @UrlAddress = UrlAddress
    ELSE
        BEGIN
            DECLARE @rows INT, @maxRows INT
            SET @rows = (SELECT COUNT(*) FROM Cache);
            SET @maxRows = (SELECT TOP 1 Value FROM Parameters);
            IF (@rows = @maxRows)   -- FULL
                BEGIN
                    DECLARE @UrlAddressRemove CHAR(30), @LastTimeRemove DATETIME
                    SELECT TOP 1 @UrlAddressRemove = UrlAddress, @LastTimeRemove = LastAccess FROM Cache ORDER BY LastAccess
                    IF EXISTS (SELECT 1 FROM History WHERE @UrlAddressRemove = UrlAddress)
                        UPDATE History SET LastAccess = @LastTimeRemove WHERE @UrlAddressRemove = UrlAddress
                    ELSE
                        INSERT INTO History VALUES(@UrlAddressRemove, @LastTimeRemove)

                    DELETE FROM Cache WHERE @UrlAddressRemove = UrlAddress
                    INSERT INTO Cache VALUES(@UrlAddress, GETDATE())
                END
            ELSE
                INSERT INTO Cache VALUES(@UrlAddress, GETDATE())
        END
END
GO

INSERT INTO Parameters VALUES('a', 3)

INSERT INTO Cache(UrlAddress) VALUES('a')
INSERT INTO Cache(UrlAddress) VALUES('b')
INSERT INTO Cache(UrlAddress) VALUES('c')
INSERT INTO Cache(UrlAddress) VALUES('d')
INSERT INTO Cache(UrlAddress) VALUES('a')
INSERT INTO Cache(UrlAddress) VALUES('grs')


SELECT * FROM Cache ORDER BY LastAccess
SELECT * FROM History ORDER BY LastAccess

INSERT INTO Cache(UrlAddress) VALUES('d')
INSERT INTO Cache(UrlAddress) VALUES('test')

SELECT * FROM Cache ORDER BY LastAccess
SELECT * FROM History ORDER BY LastAccess