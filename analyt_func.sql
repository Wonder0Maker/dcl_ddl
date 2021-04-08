USE AdventureWorks2019;
GO

----------------------------

 -- QUERY 1

SELECT 
	mt.Name
	, mt.TotalDue
FROM (
	SELECT 
		p.Name
		, SUM(sod.LineTotal) AS TotalDue
		, NTILE(10) OVER(
		  ORDER BY	p.Name) AS PerRank
	FROM	Sales.SalesOrderHeader AS soh
	JOIN	Sales.SalesOrderDetail AS sod
		ON	soh.SalesOrderID = sod.SalesOrderID
	JOIN	Production.Product	AS p
		ON	sod.ProductID = p.ProductID
	WHERE	YEAR(soh.DueDate) = 2013 
		AND MONTH(soh.DueDate) = 01
	GROUP BY	p.Name
	)	AS mt
WHERE	mt.PerRank BETWEEN 2 AND 9

---------------------------------

-- QUERY 2

SELECT	
	mt.ProductSubcategoryID
	, mt.Name	AS	ProdName
	, mt.ListPrice	AS	ProdPrice
FROM	(
	SELECT 
		Name
		, ProductSubcategoryID
		, ListPrice
		, DENSE_RANK() OVER(
		  PARTITION BY	ProductSubcategoryID 
		  ORDER BY ListPrice) AS RowNumber
	FROM	Production.Product 
	WHERE	ProductSubcategoryID IS NOT NULL
	) AS mt
WHERE	RowNumber = 1



-----------------------------------

-- QUERY 3

SELECT	MAX(mt.ListPrice) AS MaxPrice
FROM	(
	SELECT 
		Name
		, ListPrice
		, DENSE_RANK() OVER(
		  ORDER BY ListPrice DESC) AS RowNumber
	FROM	Production.Product 
	WHERE	ProductSubcategoryID = 1
	) AS mt
WHERE	RowNumber = 2
------------------------------

-- QUERY 4
 
SELECT 
	mt.ProductCategoryID
	, mt.Sale
	, (mt.Sale - mt.PrevSale)/mt.Sale as AvgSale
FROM (
	SELECT 
		pc.ProductCategoryID
		, Year(soh.DueDate) as SoldYear
		, SUM(sod.LineTotal) AS Sale 
		, LAG(SUM(soh.TotalDue)) OVER (
		  ORDER BY	pc.ProductCategoryID)
		  AS PrevSale 
	FROM	Sales.SalesOrderHeader AS soh
	JOIN	Sales.SalesOrderDetail AS sod
		ON	soh.SalesOrderID = sod.SalesOrderID
	JOIN	Production.Product AS p
		ON	sod.ProductID = p.ProductID
	JOIN	Production.ProductSubcategory AS ps
		ON	p.ProductSubcategoryID = ps.ProductSubcategoryID
	JOIN	Production.ProductCategory AS pc
		ON	ps.ProductCategoryID = pc.ProductCategoryID
	WHERE	YEAR(soh.DueDate) between 2012 and 2013 
	GROUP BY	pc.ProductCategoryID, Year(soh.DueDate)
) AS mt
WHERE mt.SoldYear = 2013
-------------------------

-- QUERY 5

SELECT 
	FORMAT(soh.OrderDate,'dd-MM-yyyy') AS SaleDate
	, FIRST_VALUE(MAX(sod.LineTotal)) OVER (
	  PARTITION BY	soh.OrderDate 
	  ORDER BY soh.OrderDate ) AS	MaxSale
FROM	Sales.SalesOrderHeader	AS soh
JOIN	Sales.SalesOrderDetail	AS sod
	ON	soh.SalesOrderID = sod.SalesOrderID
WHERE	YEAR(soh.OrderDate) = 2013 
	AND MONTH(soh.OrderDate) = 01
GROUP BY soh.OrderDate


----------------------------------

-- QUERY 6

SELECT 
	ps.Name	AS SubCatName
	, FIRST_VALUE(p.Name) OVER (
	  PARTITION BY	ps.Name
	  ORDER BY	COUNT(p.Name) DESC) 
	  AS	RowNumber
FROM	Sales.SalesOrderHeader	AS soh
JOIN	Sales.SalesOrderDetail	AS sod
	ON	soh.SalesOrderID = sod.SalesOrderID
JOIN	Production.Product	AS p
	ON	sod.ProductID = p.ProductID
JOIN	Production.ProductSubcategory	AS ps
	ON	p.ProductSubcategoryID = ps.ProductSubcategoryID
WHERE	YEAR(soh.DueDate) = 2013 
	AND	MONTH(soh.DueDate) = 01
GROUP BY ps.Name, p.Name

