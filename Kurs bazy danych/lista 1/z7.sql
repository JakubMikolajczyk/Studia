-- CREATE TABLE Test
-- (TestID int IDENTITY(1000, 10)  NOT NULL, 
--  str varchar(20) NULL,
--  PRIMARY KEY (TestID),
-- );

-- INSERT into Test (str) Values ('dfg');
-- INSERT into Test (str) Values ('dhf');
-- INSERT into Test (str) Values ('afsg');
-- INSERT into Test (str) Values ('eh');

-- SELECT * FROM [dbo].[Test]

-- INSERT INTO [dbo].[Test] (str) VALUES ('dgh')

SELECT @@IDENTITY
-- returns the last identity value generated for any table in the current session, across all scopes.

SELECT IDENT_CURRENT('Test')
-- returns the last identity value generated for a specific table in any session and any scope.


-- DROP TABLE Test