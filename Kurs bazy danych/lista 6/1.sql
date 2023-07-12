
CREATE TABLE default_(
	[ID]					INT PRIMARY KEY,
	[Patient]				VARCHAR(50),
	[Patient Address]		VARCHAR(100),
	[Appointment time and location] VARCHAR(100),
	[Price]					MONEY,
	[Physician]				VARCHAR(50),
	[Appointment cause]			VARCHAR(100))

--- 1NF

CREATE TABLE 1NF(
	[ID]                    INT PRIMARY KEY,
	[Patient]               VARCHAR(50),
	[Address]               VARCHAR(100),
    [Zip Code]              VARCHAR(10),
    [City]                  VARCHAR(20), 
	[Appointment Date]      DATETIME,
    [Appointment Room]      INT,
	[Price]                 MONEY,
	[Physician]				VARCHAR(50),
	[Appointment TYPE]	    VARCHAR(50),
    [Appointment Cause]     VARCHAR(100))


--- 2NF 

CREATE TABLE 2NFPatient(
    [ID]                    INT PRIMARY KEY,
	[Patient]               VARCHAR(50),
	[Address]               VARCHAR(100),
    [Zip Code]              VARCHAR(10),
    [City]                  VARCHAR(20)
)

CREATE TABLE 2NFAppointment(
    [Appointment ID]        INT,
    [Patient ID]            INT,
    [Appointment Date]      DATETIME,
    [Appointment Room]      INT,
    [Price]                 MONEY,
	[Physician]				VARCHAR(50),
	[Appointment TYPE]	    VARCHAR(50),
    [Appointment Cause]     VARCHAR(100)
)


--- 3NF

CREATE TABLE 3NFPatient(
    [ID]                    INT PRIMARY KEY,
	[Patient]               VARCHAR(50),
	[Address]               VARCHAR(100),
    [Zip Code]              VARCHAR(10)
)

CREATE TABLE 3NFCity(
    [Zip Code]              VARCHAR(10),
    [City]                  VARCHAR(20)
)

CREATE TABLE 3NFAppointment(
    [Appointment ID]        INT,
    [Patient ID]            INT,
    [Appointment Date]      DATETIME,
    [Price]                 MONEY,
	[Physician]				VARCHAR(50),
    [Appointment Cause]     VARCHAR(100)
)


CREATE TABLE 3NFPhysician(
    [Physician]				VARCHAR(50),
    [Appointment TYPE]	    VARCHAR(50),
    [Appointment Room]      INT,
)