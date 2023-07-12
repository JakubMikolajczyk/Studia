SELECT 
    ProductModel.Name, 
    COUNT(ProductModel.ProductModelID) AS Counter
FROM SalesLT.Product
INNER JOIN SalesLT.ProductModel
ON ProductModel.ProductModelID = Product.ProductModelID
GROUP BY(ProductModel.Name) 
HAVING COUNT(ProductModel.ProductModelID) > 1