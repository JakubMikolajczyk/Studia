DROP PROCEDURE IF EXISTS z4
GO

DROP TYPE IF EXISTS Readers
GO

CREATE TYPE Readers AS TABLE(reader_id INT)
GO

CREATE PROCEDURE z4 @readers Readers READONLY AS
BEGIN
	SELECT 
		input.reader_id, SUM(wyp.Liczba_Dni) AS sum_days
	FROM	
		@readers as input,
		Library.dbo.Czytelnik as czyt,
		Library.dbo.Wypozyczenie as wyp
	WHERE
		czyt.Czytelnik_ID = wyp.Czytelnik_ID AND
		czyt.Czytelnik_ID = input.reader_id
	GROUP BY 
		input.reader_id
END
GO

DECLARE @reader_id Readers
INSERT INTO @reader_id VALUES (1)
INSERT INTO @reader_id VALUES (2)

EXEC z4 @reader_id
GO