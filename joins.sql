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
FROM	Person.Person p 	
JOIN	HumanResources.Employee AS e
	ON	(p.BusinessEntityID = e.BusinessEntityID);
GO

SELECT	p.FirstName
	,p.LastName
	,(SELECT e.JobTitle
	FROM	HumanResources.Employee e
	WHERE	p.BusinessEntityID = e.BusinessEntityID)
	AS	JobTitle
FROM	Person.Person p
WHERE	
	(SELECT	e.JobTitle
	FROM	HumanResources.Employee e
	WHERE	p.BusinessEntityID = e.BusinessEntityID)
	IS NOT NULL;
GO

SELECT DISTINCT	
	p.FirstName
	,p.LastName
	,e.JobTitle
FROM	Person.Person AS p
FULL JOIN	HumanResources.Employee AS e
	ON	(p.BusinessEntityID = e.BusinessEntityID);
GO

SELECT	COUNT(*) AS myCount
FROM (SELECT DISTINCT	
	p.FirstName
	,p.LastName
	,e.JobTitle
	FROM	Person.Person AS p
	FULL JOIN	HumanResources.Employee AS e
		ON	(p.BusinessEntityID = e.BusinessEntityID)) 
	AS newCount;
GO

