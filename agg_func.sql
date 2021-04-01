USE	AdventureWorks2019
GO

-- Query 1
SELECT	COUNT(DISTINCT	d.GroupName ) 
FROM	HumanResources.Department AS d;
GO

--Query 2
SELECT	
	eph.BusinessEntityID
	, MAX(eph.Rate) AS MaxSalary
FROM	HumanResources.EmployeePayHistory AS eph
GROUP BY	eph.BusinessEntityID;
GO

--Query 3
SELECT	
	ps.Name
	, MIN(sod.UnitPrice) AS ProductMinimalCost
FROM  Sales.SalesOrderHeader AS soh
LEFT JOIN	Sales.SalesOrderDetail AS sod
	ON	soh.SalesOrderID = sod.SalesOrderID
LEFT JOIN	Production.Product AS p
	ON	sod.ProductID = p.ProductID
LEFT JOIN	Production.ProductSubcategory AS ps
	ON	p.ProductSubcategoryID = ps.ProductSubcategoryID
GROUP BY	ps.Name;
GO

--Query 4
SELECT	
	pc.Name
	, COUNT(*) AS NumberOfSubcategories
FROM	Production.ProductSubcategory AS ps
JOIN	Production.ProductCategory AS pc
	ON	ps.ProductCategoryID = pc.ProductCategoryID
GROUP BY	pc.Name;
GO

--Query 5
SELECT	
	ps.Name
	, AVG(soh.TotalDue) AS OrderAverageCost
FROM  Sales.SalesOrderHeader AS soh
LEFT JOIN	Sales.SalesOrderDetail AS sod
	ON	soh.SalesOrderID = sod.SalesOrderID
LEFT JOIN	Production.Product AS p
	ON	sod.ProductID = p.ProductID
LEFT JOIN	Production.ProductSubcategory AS ps
	ON	p.ProductSubcategoryID = ps.ProductSubcategoryID
GROUP BY	ps.Name;
GO

--Query 6
SELECT 
	TOP(1)
	eph.BusinessEntityID
	, e.HireDate
	, MAX(eph.Rate) AS MaxRate
FROM	HumanResources.EmployeePayHistory AS eph
JOIN	HumanResources.Employee AS e
	ON	eph.BusinessEntityID = e.BusinessEntityID
GROUP BY
	eph.BusinessEntityID
	, e.HireDate
ORDER BY	MAX(eph.Rate) DESC;
GO

