DROP TABLE IF EXISTS Wypozyczenie;
GO

DROP TABLE IF EXISTS Egzemplarz;
GO

DROP TABLE IF EXISTS Czytelnik;
GO

DROP TABLE IF EXISTS Ksiazka;
GO

CREATE TABLE Ksiazka
( Ksiazka_ID INT IDENTITY
, ISBN VARCHAR(20)
, Tytul VARCHAR(300)
, Autor VARCHAR(200)
, Rok_Wydania INT
, Cena DECIMAL(10,2)
, Wypozyczona_Ostatni_Miesiac BIT
, CONSTRAINT Ksiazka_PK PRIMARY KEY (Ksiazka_ID)
, CONSTRAINT Ksiazka_UK_ISBN UNIQUE (ISBN)
);
GO

CREATE TABLE Egzemplarz
( Egzemplarz_ID INT IDENTITY PRIMARY KEY
, Sygnatura CHAR(8) UNIQUE
, Ksiazka_ID INT FOREIGN KEY REFERENCES Ksiazka(Ksiazka_ID)
);
GO

CREATE TABLE Czytelnik
( Czytelnik_ID INT IDENTITY
, PESEL CHAR(11)
, Nazwisko VARCHAR(30)
, Miasto VARCHAR(30)
, Data_Urodzenia DATE
, Ostatnie_Wypozyczenie DATE
, CONSTRAINT Czytelnik_PK PRIMARY KEY (Czytelnik_ID)
, CONSTRAINT Czytelnik_UK_PESEL UNIQUE (PESEL)
);
GO

CREATE TABLE Wypozyczenie
( Wypozyczenie_ID INT IDENTITY
, Czytelnik_ID INT
, Egzemplarz_ID INT
, Data DATE
, Liczba_Dni INT
, CONSTRAINT Wypozyczenie_PK PRIMARY KEY (Wypozyczenie_ID)
, CONSTRAINT Wypozyczenie_FK_Czytelnik FOREIGN KEY (Czytelnik_ID) REFERENCES Czytelnik (Czytelnik_ID) ON DELETE CASCADE
, CONSTRAINT Wypozyczenie_FK_Egzemplarz FOREIGN KEY (Egzemplarz_ID) REFERENCES Egzemplarz (Egzemplarz_ID) ON DELETE CASCADE
);
GO

SET IDENTITY_INSERT Ksiazka ON
INSERT INTO Ksiazka (Ksiazka_ID,ISBN,Tytul,Autor,Rok_Wydania,Cena) VALUES
(1,'83-246-0279-8','Microsoft Access. Podr�cznik administratora','Helen Feddema',2006,69),
(2,'83-246-0653-X','SQL Server 2005. Programowanie. Od podstaw','Robert Vieira',2007,97),
(3,'978-83-246-0549-1','SQL Server 2005. Wyci�nij wszystko','Eric L. Brown',2007,57),
(4,'978-83-246-1258-1','PHP, MySQL i MVC. Tworzenie witryn WWW opartych na bazie danych','W�odzimierz Gajda',2010,79),
(5,'978-83-246-2060-9','Access 2007 PL. Seria praktyk','Andrew Unsworth',2009,39),
(6,'978-83-246-2188-0','Czysty kod. Podr�cznik dobrego programisty','Robert C. Martin',2010,67);
SET IDENTITY_INSERT Ksiazka OFF
GO

SET IDENTITY_INSERT Egzemplarz ON
INSERT INTO Egzemplarz (Egzemplarz_ID,Ksiazka_ID,Sygnatura) VALUES
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
SET IDENTITY_INSERT Egzemplarz OFF
GO

SET IDENTITY_INSERT Czytelnik ON
INSERT INTO Czytelnik (CZYTELNIK_ID,PESEL,NAZWISKO,MIASTO,DATA_URODZENIA) VALUES
(1, '55101011111', 'Kowalski', 'Wroclaw',  '1955-10-10'),
(2, '60101033333', 'Maliniak', 'Wroclaw',  '1960-10-10'),
(3, '65120122222', 'Nowak',    'Warszawa', '1965-12-01'),
(4, '55010111111', 'dsg',    'Swidnica', '1955-01-01'),
(5, '99020222222', 'afsdg',   'adg',  '1999-02-02'),
(6, '98030333333', 'sdfag',  'fsg',     '1998-03-03')
SET IDENTITY_INSERT Czytelnik OFF
GO

SET IDENTITY_INSERT Wypozyczenie ON
INSERT INTO Wypozyczenie (Wypozyczenie_ID,Czytelnik_ID,Egzemplarz_ID,Data,Liczba_Dni) VALUES
(1, 4, 26, '2019-7-11', 57),
(2, 3, 21, '2019-3-17', 87),
(3, 6, 6, '2019-1-20', 74),
(4, 4, 1, '2019-2-13', 9),
(5, 3, 17, '2019-11-24', 83),
(6, 3, 8, '2019-4-18', 84),
(7, 6, 1, '2019-6-16', 46),
(8, 1, 4, '2019-9-7', 10),
(9, 5, 46, '2019-1-3', 29),
(10, 6, 33, '2019-6-20', 73),
(11, 1, 2, '2019-7-13', 75),
(12, 1, 37, '2019-11-14', 19),
(13, 5, 16, '2019-3-23', 45),
(14, 6, 15, '2019-7-19', 64),
(15, 2, 9, '2019-7-8', 86),
(16, 2, 20, '2019-8-2', 84),
(17, 3, 20, '2019-3-1', 84),
(18, 4, 8, '2019-7-24', 66),
(19, 3, 9, '2019-10-24', 55),
(20, 4, 35, '2019-8-19', 3),
(21, 5, 19, '2019-2-21', 74),
(22, 5, 40, '2019-12-18', 40),
(23, 5, 29, '2019-3-28', 46),
(24, 2, 17, '2019-7-7', 70),
(25, 1, 41, '2019-12-11', 50),
(26, 3, 5, '2019-4-16', 55),
(27, 1, 13, '2019-3-28', 79),
(28, 4, 23, '2019-12-1', 39),
(29, 3, 23, '2019-6-22', 67),
(30, 2, 14, '2019-3-5', 18),
(31, 1, 6, '2019-5-19', 94),
(32, 5, 25, '2019-12-6', 23),
(33, 6, 48, '2019-3-11', 2),
(34, 5, 37, '2019-9-27', 19),
(35, 4, 34, '2019-1-11', 6),
(36, 1, 43, '2019-4-8', 2),
(37, 4, 7, '2019-10-17', 88),
(38, 4, 22, '2019-5-17', 96),
(39, 5, 3, '2019-9-6', 68),
(40, 1, 28, '2019-5-20', 21),
(41, 1, 20, '2019-8-23', 81),
(42, 3, 30, '2019-2-8', 54),
(43, 1, 39, '2019-1-20', 15),
(44, 6, 6, '2019-10-1', 80),
(45, 5, 14, '2019-10-22', 86),
(46, 4, 13, '2019-1-4', 79),
(47, 1, 36, '2019-11-7', 83),
(48, 5, 31, '2019-2-20', 95),
(49, 6, 1, '2019-1-16', 19),
(50, 6, 48, '2019-12-27', 85),
(51, 1, 40, '2019-3-15', 87),
(52, 2, 8, '2019-3-22', 92),
(53, 5, 39, '2019-8-28', 25),
(54, 5, 27, '2019-11-1', 63),
(55, 1, 50, '2019-8-16', 99),
(56, 2, 18, '2019-11-15', 70),
(57, 6, 41, '2019-1-23', 14),
(58, 3, 43, '2019-5-9', 71),
(59, 5, 2, '2019-3-28', 21),
(60, 1, 37, '2019-2-9', 28),
(61, 6, 11, '2019-12-24', 98),
(62, 5, 20, '2019-12-28', 37),
(63, 6, 23, '2019-11-28', 27),
(64, 3, 34, '2019-7-13', 43),
(65, 4, 27, '2019-1-23', 65),
(66, 2, 5, '2019-11-20', 82),
(67, 2, 30, '2019-6-28', 29),
(68, 2, 24, '2019-7-5', 5),
(69, 4, 21, '2019-9-28', 45),
(70, 2, 10, '2019-3-27', 84),
(71, 2, 2, '2019-6-11', 91),
(72, 5, 10, '2019-6-2', 87),
(73, 4, 29, '2019-2-21', 27),
(74, 5, 38, '2019-1-16', 96),
(75, 4, 21, '2019-10-24', 58),
(76, 4, 23, '2019-4-27', 85),
(77, 2, 35, '2019-5-20', 64),
(78, 4, 1, '2019-3-2', 88),
(79, 6, 23, '2019-10-17', 22),
(80, 2, 4, '2019-12-18', 27),
(81, 1, 34, '2019-8-11', 57),
(82, 1, 46, '2019-10-24', 99),
(83, 3, 50, '2019-9-3', 35),
(84, 2, 42, '2019-7-10', 58),
(85, 6, 29, '2019-9-9', 15),
(86, 2, 44, '2019-7-8', 18),
(87, 2, 43, '2019-6-11', 77),
(88, 6, 45, '2019-8-9', 29),
(89, 4, 37, '2019-6-10', 32),
(90, 5, 45, '2019-7-15', 5),
(91, 1, 49, '2019-10-20', 17),
(92, 3, 32, '2019-10-12', 30),
(93, 1, 33, '2019-6-9', 59),
(94, 5, 27, '2019-12-8', 30),
(95, 1, 7, '2019-9-26', 31),
(96, 2, 22, '2019-2-8', 64),
(97, 1, 43, '2019-4-4', 88),
(98, 2, 16, '2019-2-23', 21),
(99, 1, 36, '2019-2-18', 32),
(100, 5, 11, '2019-4-3', 34)
SET IDENTITY_INSERT Wypozyczenie OFF
GO