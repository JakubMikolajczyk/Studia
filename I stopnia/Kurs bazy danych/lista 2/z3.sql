DELETE FROM Library.dbo.Czytelnik WHERE Czytelnik.Czytelnik_ID > 3

GO
DROP PROCEDURE IF EXISTS z3
GO

CREATE PROCEDURE z3 @PESEL CHAR(11), @surname CHAR(20), @city CHAR(20), @bDate DATE AS
BEGIN

    IF  NOT (91 > UNICODE(@surname) AND UNICODE(@surname) > 64)
        THROW 50001, 'Wrog first letter', 1;


    IF @surname NOT LIKE '[a-z][a-z][a-z]%'         -- '___%' not work
        THROW 50001, 'Wrog surname len', 1;

    -- IF @surname NOT LIKE '[A-Z]__%'
    --     BEGIN
    --         ;THROW 50001, 'Wrog surname', 1;
    --     END
    
    IF ISNUMERIC(@PESEL) = 0
        THROW 50001, 'PESEL is not number', 1;

    IF LEN(@PESEL) != 11
        THROW 50001, 'Wrong len', 1;

    DECLARE @pYear CHAR(2) 
    DECLARE @pMonth CHAR(2)
    DECLARE @pDay CHAR(2)

    SET @pYear = SUBSTRING(@PESEL, 1, 2)
    SET @pMonth = SUBSTRING(@PESEL, 3, 2)
    SET @pDay = SUBSTRING(@PESEL, 5, 2)

    IF (YEAR(@bDate) % 100) != @pYear
        THROW 50001, 'Wrong year', 1;
    
    IF DAY(@bDate) != @pDay
        THROW 50001, 'Wrong day', 1;

    IF YEAR(@bDate) < 2000
        BEGIN
            IF MONTH(@bDate) != @pMonth
                THROW 50001, 'Wrong month', 1;
        END
    ELSE
        BEGIN
            IF MONTH(@bDate)!= (@pMonth - 20)
                THROW 50001, 'Wrong month', 1;
        END
    
    INSERT INTO Library.dbo.Czytelnik VALUES(@PESEL, @surname, @city, @bDate, NULL)

END
GO

EXEC z3 @PESEL='01221412340', @surname = 'Mikolajczyk', @city='Zgorzelec', @bDate='2001-02-14'
GO
EXEC z3 @PESEL='01221412341', @surname = 'agb', @city='Zgorzelec', @bDate='2001-02-14'
GO
EXEC z3 @PESEL='01221412341', @surname = 'Ag', @city='Zgorzelec', @bDate='2001-02-14'
GO
EXEC z3 @PESEL='01221412341', @surname = 'Agggf24', @city='Zgorzelec', @bDate='2001-02-14'
GO
EXEC z3 @PESEL='123', @surname = 'Mikolajczyk', @city='Zgorzelec', @bDate='2001-02-14'
GO
EXEC z3 @PESEL='01221412342', @surname = 'Mikolajczyk', @city='Zgorzelec', @bDate='2002-02-14'
GO
EXEC z3 @PESEL='01221412343', @surname = 'Mikolajczyk', @city='Zgorzelec', @bDate='2001-05-14'
GO
EXEC z3 @PESEL='01221412344', @surname = 'Mikolajczyk', @city='Zgorzelec', @bDate='2001-02-20'
GO
EXEC z3 @PESEL='01221412345', @surname = 'Mikolajczyk', @city='Zgorzelec', @bDate='2001-02-14'
GO
EXEC z3 @PESEL='dsfsg', @surname = 'Mikolajczyk', @city='Zgorzelec', @bDate='2001-02-14'
GO