DROP TABLE IF EXISTS firstname

CREATE TABLE firstname(id INT PRIMARY KEY, firstname CHAR(20))

INSERT INTO firstname VALUES(1, 'Kuba')
INSERT INTO firstname VALUES(2, 'Wiktor')
INSERT INTO firstname VALUES(3, 'Dominik')
INSERT INTO firstname VALUES(4, 'Amelia')
INSERT INTO firstname VALUES(5, 'Klaudia')
INSERT INTO firstname VALUES(6, 'Mateusz')

DROP TABLE IF EXISTS surname


CREATE TABLE surname(id INT PRIMARY KEY, surname CHAR(20))

INSERT INTO surname VALUES(1, 'Kowalski')
INSERT INTO surname VALUES(2, 'Nowak')
INSERT INTO surname VALUES(3, 'Aaa')
INSERT INTO surname VALUES(4, 'Bbb')
INSERT INTO surname VALUES(5, 'Ccc')

DROP TABLE IF EXISTS fldata
CREATE TABLE fldata(firstname CHAR(20), surname CHAR(20), PRIMARY KEY(firstname, surname))


DROP PROCEDURE IF EXISTS z2
GO
CREATE PROCEDURE z2 @n INT AS
BEGIN
    DELETE FROM Library.dbo.fldata

    DECLARE @a INT
    DECLARE @b INT

    SET @a = (SELECT COUNT(id) FROM Library.dbo.firstname)
    SET @b = (SELECT COUNT(id) FROM Library.dbo.surname)

    IF (@n > @a * @b)
            THROW 50001, 'n is bigger than all possible pairs', 1;
    
    INSERT INTO fldata 
        SELECT TOP(@n) firstname, surname FROM Library.dbo.firstname, Library.dbo.surname ORDER BY NEWID()

    SELECT * FROM fldata
END
GO
EXEC z2 @n = 11