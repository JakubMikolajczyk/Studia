SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

--- DIRTY
-- BEGIN TRAN
-- UPDATE transactionTest SET name = 'dfgdhf' WHERE id = 1
-- WAITFOR DELAY '00:00:05'
-- ROLLBACK

---nonrepeatable read
-- BEGIN TRAN
-- UPDATE transactionTest SET name = 'dfgdhf' WHERE id = 1
-- WAITFOR DELAY '00:00:05'
-- COMMIT

--- phantom
-- BEGIN TRAN
-- DELETE FROM transactionTest WHERE id = 1
-- WAITFOR DELAY '00:00:05'
-- COMMIT