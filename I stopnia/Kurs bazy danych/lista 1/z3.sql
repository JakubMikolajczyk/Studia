SELECT 
    Address.City,
    COUNT(CustomerAddress.CustomerID) AS Customers,
    COUNT(DISTINCT Customer.SalesPerson) AS SalesPerson
FROM SalesLT.Address, SalesLT.Customer, SalesLT.CustomerAddress
WHERE Customer.CustomerID = CustomerAddress.CustomerID
    AND Address.AddressID = CustomerAddress.AddressID 
GROUP BY City