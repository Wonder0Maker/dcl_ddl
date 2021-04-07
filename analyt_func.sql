USE AdventureWorks2019;
GO

----------------------------

 -- QUERY 1

SELECT 
	mt.ProductID
	, mt.TotalDue
FROM (
	SELECT 
		p.ProductID
		, SUM(sod.UnitPrice) AS TotalDue
		, PERCENT_RANK() OVER(ORDER BY	p.ProductID) AS PerRank
	FROM	Sales.SalesOrderHeader AS soh
	JOIN	Sales.SalesOrderDetail AS sod
		ON	soh.SalesOrderID = sod.SalesOrderID
	JOIN	Production.Product	AS p
		ON	sod.ProductID = p.ProductID
	WHERE	YEAR(soh.DueDate) = 2013 
		AND MONTH(soh.DueDate) = 01
	GROUP BY	p.ProductID, sod.UnitPrice
	)	AS mt
WHERE	mt.PerRank BETWEEN 0.1 AND 0.9
GROUP BY	mt.TotalDue, mt.ProductID, mt.PerRank
ORDER BY	mt.ProductID
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
		, ROW_NUMBER() OVER(PARTITION BY ProductSubcategoryID 
		  ORDER BY ListPrice) AS RowNumber
	FROM	Production.Product 
	WHERE	ProductSubcategoryID IS NOT NULL
	GROUP BY	Name, ProductSubcategoryID, ListPrice
	) AS mt
WHERE	RowNumber = 1
-----------------------------------

-- QUERY 3

SELECT	
	mt.Name
	, mt.ListPrice
FROM	(
	SELECT 
		Name
		, ListPrice
		, ROW_NUMBER() OVER(ORDER BY ListPrice DESC) AS RowNumber
	FROM	Production.Product 
	WHERE	Name LIKE 'Mountain-%'
	GROUP BY	Name, ListPrice
	) AS mt
WHERE	RowNumber = 2
------------------------------

-- QUERY 4

SELECT 
	mt.ProductCategoryID,
	mt.MetYoY
FROM (
	SELECT 
		pc.ProductCategoryID
		, Year(soh.DueDate) as Year
		, (SUM(soh.TotalDue) - LAG(SUM(soh.TotalDue)) 
		  OVER (ORDER BY pc.ProductCategoryID)) / SUM(soh.TotalDue) AS MetYoY
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
	mt.DueDate
	, mt.LineTotal
FROM	(
	SELECT 
		sod.LineTotal
		, soh.DueDate
		, ROW_NUMBER() OVER (PARTITION BY soh.DueDate 
		  ORDER BY sod.LineTotal desc) AS	RowNumber
	FROM	Sales.SalesOrderHeader	AS soh
	JOIN	Sales.SalesOrderDetail	AS sod
		ON	soh.SalesOrderID = sod.SalesOrderID
	WHERE	YEAR(soh.DueDate) = 2013 
		AND MONTH(soh.DueDate) = 01
	) AS mt
WHERE	RowNumber = 1
----------------------------------

-- QUERY 6

SELECT 
	mt.SubCatName
	, mt.ProdName
	, mt.BiggerCount
FROM	(
	SELECT 
		p.ProductID
		, p.Name	AS ProdName
		, ps.Name	AS SubCatName
		, ps.ProductSubcategoryID
		, COUNT(*)	AS BiggerCount
		, ROW_NUMBER() OVER (PARTITION BY ps.ProductSubcategoryID 
		  ORDER BY	COUNT(p.ProductID) DESC) AS	RowNumber
	FROM	Sales.SalesOrderHeader	AS soh
	JOIN	Sales.SalesOrderDetail	AS sod
		ON	soh.SalesOrderID = sod.SalesOrderID
	JOIN	Production.Product	AS p
		ON	sod.ProductID = p.ProductID
	JOIN	Production.ProductSubcategory	AS ps
		ON	p.ProductSubcategoryID = ps.ProductSubcategoryID
	WHERE	YEAR(soh.DueDate) = 2013 
		AND	MONTH(soh.DueDate) = 01
	GROUP BY	p.ProductID, ps.ProductSubcategoryID, p.Name , ps.Name
	) AS	mt
WHERE	RowNumber = 1


