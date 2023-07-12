SELECT DISTINCT City
  FROM SalesLT.Address 
  INNER JOIN SalesLT.SalesOrderHeader
  ON Address.AddressID = SalesOrderHeader.ShipToAddressID 
  AND SalesOrderHeader.DueDate < '2023-03-05'
  ORDER BY City ASC