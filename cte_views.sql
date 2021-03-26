USE AdventureWorks2019;
GO

-- Query 1
CREATE VIEW Person.vPerson
AS
SELECT
	p.Title
	, p.FirstName
	, p.LastName
	, ea.EmailAddress
FROM	Person.Person AS p
JOIN	Person.EmailAddress AS ea
	ON	p.BusinessEntityID = ea.BusinessEntityID;
GO

SELECT	*
FROM	Person.vPerson;
GO

-- Query 2
WITH Emploee_CTE
AS
(
	SELECT	
		e.BusinessEntityID
		, e.NationalIDNumber
		, e.JobTitle
		, p.FirstName
		, p.LastName
		, pp.PhoneNumber
	FROM	HumanResources.Employee AS e
	JOIN	Person.Person AS p
		ON	e.BusinessEntityID = p.BusinessEntityID
	LEFT JOIN	Person.PersonPhone AS pp
		ON	e.BusinessEntityID = pp.BusinessEntityID
)

SELECT	* 
FROM	Emploee_CTE;
GO
