USE AdventureWorks2019;
GO

SELECT	p.FirstName
	,p.LastName
	,e.JobTitle
	,e.BirthDate
FROM	Person.Person AS p
JOIN	HumanResources.Employee AS e
	ON	(p.BusinessEntityID = e.BusinessEntityID);
GO

SELECT	p.FirstName
	,p.LastName
	,(SELECT e.JobTitle
	FROM	HumanResources.Employee e
	WHERE	p.BusinessEntityID = e.BusinessEntityID)
	AS	JobTitle
FROM	Person.Person p;
GO


SELECT	MyTable.FirstName
	,MyTable.LastName
	,MyTable.JobTitle
FROM	(SELECT p.FirstName
	,p.LastName
	,e.JobTitle
	FROM	Person.Person AS p
	JOIN	HumanResources.Employee AS e
	ON	(p.BusinessEntityID = e.BusinessEntityID)) 
	AS MyTable;


SELECT DISTINCT	
	p.FirstName
	,p.LastName
	,e.JobTitle
FROM	Person.Person AS p
CROSS JOIN	HumanResources.Employee AS e;
GO

SELECT	COUNT(*) AS myCount
FROM	(SELECT DISTINCT	
	p.FirstName
	,p.LastName
	,e.JobTitle
	FROM	Person.Person AS p
	CROSS JOIN	HumanResources.Employee AS e) 
	AS newCount;
GO

