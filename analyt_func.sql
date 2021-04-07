USE AdventureWorks2019;
GO

----------------------------

 -- QUERY 1

SELECT 
	mt.Name
	, mt.TotalDue
FROM (
	SELECT 
		p.ProductID
		, p.Name
		, SUM(sod.UnitPrice) AS TotalDue
		, NTILE(10) OVER(
		  ORDER BY	p.ProductID) AS PerRank
	FROM	Sales.SalesOrderHeader AS soh
	JOIN	Sales.SalesOrderDetail AS sod
		ON	soh.SalesOrderID = sod.SalesOrderID
	JOIN	Production.Product	AS p
		ON	sod.ProductID = p.ProductID
	WHERE	YEAR(soh.DueDate) = 2013 
		AND MONTH(soh.DueDate) = 01
	GROUP BY	p.ProductID, sod.UnitPrice, p.Name
	)	AS mt
WHERE	mt.PerRank BETWEEN 2 AND 9
GROUP BY	mt.TotalDue, mt.Name

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
	GROUP BY	Name, ProductSubcategoryID, ListPrice
	) AS mt
WHERE	RowNumber = 1


-----------------------------------

-- QUERY 3

SELECT	MAX(mt.ListPrice)
FROM	(
	SELECT 
		Name
		, ListPrice
		, DENSE_RANK() OVER(
		  ORDER BY ListPrice DESC) AS RowNumber
	FROM	Production.Product 
	WHERE	Name LIKE 'Mountain-%'
	GROUP BY	Name, ListPrice
	) AS mt
WHERE	RowNumber = 2
------------------------------

-- QUERY 4
 
SELECT 
	mt.ProductCategoryID
	, mt.AvgSale
	, mt.AvgSale
FROM (
	SELECT 
		pc.ProductCategoryID
		, YEAR(soh.DueDate) AS Year
		, SUM(soh.TotalDue) AS Sale
		, (SUM(soh.TotalDue) - LAG(SUM(soh.TotalDue)) OVER (
		  ORDER BY	pc.ProductCategoryID)) / SUM(soh.TotalDue)
		  AS AvgSale
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
WHERE mt.Year = 2013
-------------------------

-- QUERY 5

SELECT 
	FORMAT(soh.DueDate,'dd-MM-yyyy')
	, FIRST_VALUE(MAX(sod.LineTotal)) OVER (
	  PARTITION BY	soh.DueDate 
	  ORDER BY soh.DueDate ) AS	MaxSale
FROM	Sales.SalesOrderHeader	AS soh
JOIN	Sales.SalesOrderDetail	AS sod
	ON	soh.SalesOrderID = sod.SalesOrderID
WHERE	YEAR(soh.DueDate) = 2013 
	AND MONTH(soh.DueDate) = 01
GROUP BY soh.DueDate

----------------------------------

-- QUERY 6

SELECT 
	ps.Name	AS SubCatName
	, p.Name	AS ProdName
	, FIRST_VALUE(COUNT(*)) OVER (
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
GROUP BY	p.Name , ps.Name


