SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

--- DIRTY
-- BEGIN TRAN
-- SELECT * FROM transactionTest
-- WAITFOR DELAY '00:00:05'
-- SELECT * FROM transactionTest
-- COMMIT

---nonrepeatable read
-- BEGIN TRAN
-- SELECT * FROM transactionTest
-- WAITFOR DELAY '00:00:05'
-- SELECT * FROM transactionTest
-- COMMIT

--- phantom
BEGIN TRAN
SELECT COUNT(*) FROM transactionTest
WAITFOR DELAY '00:00:05'
SELECT COUNT(*) FROM transactionTest
COMMIT
