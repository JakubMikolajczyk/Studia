SELECT * FROM Egzemplarz3
JOIN Ksiazka3 ON Egzemplarz3.Ksiazka_ID = Ksiazka3.Ksiazka_ID

SELECT Ksiazka3.Tytul FROM Egzemplarz3
JOIN Ksiazka3 ON Egzemplarz3.Ksiazka_ID = Ksiazka3.Ksiazka_ID



CREATE CLUSTERED INDEX test 
ON Egzemplarz3(Ksiazka_ID)

CREATE CLUSTERED INDEX test 
ON Ksiazka3(Ksiazka_ID)

SELECT * FROM Egzemplarz3 WITH (INDEX = test)
JOIN Ksiazka3 WITH (INDEX = test) ON Egzemplarz3.Ksiazka_ID = Ksiazka3.Ksiazka_ID

SELECT Ksiazka3.Tytul FROM Egzemplarz3 WITH (INDEX = test)
JOIN Ksiazka3 WITH (INDEX = test) ON Egzemplarz3.Ksiazka_ID = Ksiazka3.Ksiazka_ID

DROP INDEX test ON Egzemplarz3
DROP INDEX test ON Ksiazka3




CREATE NONCLUSTERED INDEX test 
ON Egzemplarz3(Ksiazka_ID)

CREATE NONCLUSTERED INDEX test 
ON Ksiazka3(Ksiazka_ID)

SELECT * FROM Egzemplarz3 WITH (INDEX = test)
JOIN Ksiazka3 WITH (INDEX = test) ON Egzemplarz3.Ksiazka_ID = Ksiazka3.Ksiazka_ID

SELECT Ksiazka3.Tytul FROM Egzemplarz3 WITH (INDEX = test)
JOIN Ksiazka3 WITH (INDEX = test) ON Egzemplarz3.Ksiazka_ID = Ksiazka3.Ksiazka_ID

DROP INDEX test ON Egzemplarz3
DROP INDEX test ON Ksiazka3





CREATE NONCLUSTERED INDEX test 
ON Egzemplarz3(Ksiazka_ID)

CREATE NONCLUSTERED INDEX test 
ON Ksiazka3(Ksiazka_ID,
            Tytul)

SELECT * FROM Egzemplarz3 WITH (INDEX = test)
JOIN Ksiazka3 WITH (INDEX = test) ON Egzemplarz3.Ksiazka_ID = Ksiazka3.Ksiazka_ID

SELECT Ksiazka3.Tytul FROM Egzemplarz3 WITH (INDEX = test)
JOIN Ksiazka3 WITH (INDEX = test) ON Egzemplarz3.Ksiazka_ID = Ksiazka3.Ksiazka_ID

DROP INDEX test ON Egzemplarz3
DROP INDEX test ON Ksiazka3