SELECT  Customer.FirstName, 
        Customer.LastName, 
        SUM(UnitPriceDiscount * OrderQty * UnitPrice) AS SumDiscount
FROM SalesLT.Customer, SalesLT.SalesOrderDetail, SalesLT.SalesOrderHeader
WHERE   SalesOrderDetail.SalesOrderID = SalesOrderHeader.SalesOrderID
        AND Customer.CustomerID = SalesOrderHeader.CustomerID
GROUP BY Customer.FirstName, Customer.LastName