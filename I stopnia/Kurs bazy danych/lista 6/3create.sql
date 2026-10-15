DROP TABLE IF EXISTS Wypozyczenie;
GO

DROP TABLE IF EXISTS Egzemplarz;
GO

DROP TABLE IF EXISTS Czytelnik;
GO

DROP TABLE IF EXISTS Ksiazka;
GO

CREATE TABLE Ksiazka3
( Ksiazka_ID INT IDENTITY
, ISBN VARCHAR(20) UNIQUE
, Tytul VARCHAR(300)
, Autor VARCHAR(200)
, Rok_Wydania INT
, Cena DECIMAL(10,2)
, Wypozyczona_Ostatni_Miesiac BIT
);
GO

CREATE TABLE Egzemplarz3
( Egzemplarz_ID INT IDENTITY
, Sygnatura CHAR(8) UNIQUE
, Ksiazka_ID INT
);
GO



SET IDENTITY_INSERT Ksiazka3 ON
INSERT INTO Ksiazka3 (Ksiazka_ID,ISBN,Tytul,Autor,Rok_Wydania,Cena) VALUES
(1,'83-246-0279-8','Microsoft Access. Podr�cznik administratora','Helen Feddema',2006,69),
(2,'83-246-0653-X','SQL Server 2005. Programowanie. Od podstaw','Robert Vieira',2007,97),
(3,'978-83-246-0549-1','SQL Server 2005. Wyci�nij wszystko','Eric L. Brown',2007,57),
(4,'978-83-246-1258-1','PHP, MySQL i MVC. Tworzenie witryn WWW opartych na bazie danych','W�odzimierz Gajda',2010,79),
(5,'978-83-246-2060-9','Access 2007 PL. Seria praktyk','Andrew Unsworth',2009,39),
(6,'978-83-246-2188-0','Czysty kod. Podr�cznik dobrego programisty','Robert C. Martin',2010,67);
SET IDENTITY_INSERT Ksiazka3 OFF
GO

SET IDENTITY_INSERT Egzemplarz3 ON
INSERT INTO Egzemplarz3 (Egzemplarz_ID,Ksiazka_ID,Sygnatura) VALUES
(1,  5, 'S0001'),
(2,  5, 'S0002'),
(3,  1, 'S0003'),
(4,  1, 'S0004'),
(5,  1, 'S0005'),
(6,  2, 'S0006'),
(7,  3, 'S0007'),
(8,  3, 'S0008'),
(9,  3, 'S0009'),
(10, 1, 'S0010'),
(11, 2, 'S0011'),
(12, 3, 'S0012'),
(13, 1, 'S0013'),
(14, 2, 'S0014'),
(15, 5, 'S0015'),
(16, 6, 'S0016'),
(17, 1, 'S0017'),
(18, 1, 'S0018'),
(19, 2, 'S0019'),
(20, 3, 'S0020'),
(21, 4, 'S0021'),
(22, 5, 'S0022'),
(23, 5, 'S0023'),
(24, 4, 'S0024'),
(25, 5, 'S0025'),
(26, 6, 'S0026'),
(27, 5, 'S0027'),
(28, 5, 'S0028'),
(29, 5, 'S0029'),
(30, 5, 'S0030'),
(31, 5, 'S0031'),
(32, 1, 'S0032'),
(33, 2, 'S0033'),
(34, 2, 'S0034'),
(35, 2, 'S0035'),
(36, 2, 'S0036'),
(37, 2, 'S0037'),
(38, 2, 'S0038'),
(39, 3, 'S0039'),
(40, 1, 'S0040'),
(41, 2, 'S0041'),
(42, 3, 'S0042'),
(43, 4, 'S0043'),
(44, 5, 'S0044'),
(45, 6, 'S0045'),
(46, 1, 'S0046'),
(47, 1, 'S0047'),
(48, 2, 'S0048'),
(49, 3, 'S0049'),
(50, 3, 'S0050')
SET IDENTITY_INSERT Egzemplarz3 OFF
