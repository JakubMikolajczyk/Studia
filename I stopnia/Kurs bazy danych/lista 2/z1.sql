DROP FUNCTION IF EXISTS z1
GO

CREATE FUNCTION z1(@days int) RETURNS TABLE
RETURN
    SELECT Czytelnik.PESEL, COUNT(Wypozyczenie.Wypozyczenie_ID) AS [specimens number]
    FROM 
    [Library].[dbo].[Czytelnik],
    [Library].[dbo].[Wypozyczenie]
    WHERE Czytelnik.Czytelnik_ID = Wypozyczenie.Czytelnik_ID AND Wypozyczenie.Liczba_dni > @days
    GROUP BY(Czytelnik.PESEL)
GO

SELECT * FROM z1(13)

SELECT * FROM z1(3)