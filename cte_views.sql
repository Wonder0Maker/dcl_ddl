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
WITH	Person_CTE(BusinessEntityID, FirstName, LastName)
AS
(
	SELECT
		p.BusinessEntityID
		, p.FirstName 
		, p.LastName
	FROM	Person.Person AS p
),

PersonPhone_CTE
AS
(
	SELECT	
		pp.BusinessEntityID
		, pp.PhoneNumber 
	FROM	Person.PersonPhone AS pp
)

SELECT	
	e.BusinessEntityID
	, e.NationalIDNumber
	, e.JobTitle
	, p.FirstName
	, p.LastName
	, pp.PhoneNumber
FROM	HumanResources.Employee AS e
JOIN	Person_CTE AS p
	ON	e.BusinessEntityID = p.BusinessEntityID
LEFT JOIN	PersonPhone_CTE AS pp
	ON	e.BusinessEntityID = pp.BusinessEntityID
