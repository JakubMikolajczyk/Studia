DECLARE @myVariable TABLE (
    ID int,
    Name CHAR(20)
)

INSERT INTO @myVariable VALUES (1, 'VAR')
INSERT INTO @myVariable VALUES (2, 'rjr')


CREATE TABLE #myLocalTab (
    ID int,
     Name CHAR(20)
)

INSERT INTO #myLocalTab VALUES (1, 'LOCAL')
INSERT INTO #myLocalTab VALUES (2, 'dgh')


CREATE TABLE ##myGlobalTab (
    ID int,
     Name CHAR(20)
)


INSERT INTO ##myGlobalTab VALUES (1, 'GLOBAL')
INSERT INTO ##myGlobalTab VALUES (2, 'gdh')


SELECT * FROM tempdb.INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME LIKE '%my%'

SELECT * FROM @myVariable
SELECT * FROM #myLocalTab
SELECT * FROM ##myGlobalTab

GO

-- SELECT * FROM @myVariable
SELECT * FROM #myLocalTab
SELECT * FROM ##myGlobalTab