SELECT  ProductCategory.Name,
        Product.Name
FROM SalesLT.Product, SalesLT.ProductCategory
WHERE ProductCategory.ProductCategoryID 
    IN (
        SELECT ProductCategory.ParentProductCategoryID 
        FROM SalesLT.ProductCategory)
    AND ProductCategory.ProductCategoryID = Product.ProductCategoryID