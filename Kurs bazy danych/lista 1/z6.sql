-- CREATE TABLE OrdersToProcess (
--     SalesOrderID int NOT NULL,
--     Delayed BIT,
--     PRIMARY KEY (SalesOrderID),
-- );

-- MERGE dbo.OrdersToProcess AS TARGET
-- USING SalesLT.SalesOrderHeader AS SOURCE

-- ON (TARGET.SalesOrderID = SOURCE.SalesOrderID)
-- WHEN MATCHED
-- THEN UPDATE
-- SET TARGET.Delayed = 
-- CASE WHEN SOURCE.DueDate > '2023-03-06' THEN 
-- 	0
-- ELSE 
-- 	1
-- END

-- WHEN NOT MATCHED BY TARGET 
-- THEN INSERT (SalesOrderID, Delayed) VALUES (SOURCE.SalesOrderID, CASE WHEN SOURCE.DueDate > '2023-03-04' THEN 
-- 	0
-- ELSE 
-- 	1
-- END)

-- WHEN NOT MATCHED BY SOURCE
-- THEN DELETE;

SELECT * FROM OrdersToProcess