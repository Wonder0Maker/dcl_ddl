USE AdventureWorks2019;
GO

SELECT	*
FROM	HumanResources.Department
WHERE	GroupName LIKE '%Research%'
ORDER BY	DepartmentID DESC;

SELECT	BusinessEntityId,
		JobTitle, 
		BirthDate, 
		Gender
FROM	HumanResources.Employee
WHERE	NationalIDNumber BETWEEN 500000000 AND 1000000000;

SELECT	BusinessEntityID,
		JobTitle,
		BirthDate,
		Gender
FROM	HumanResources.Employee
WHERE	YEAR(BirthDate) IN (1980, 1990);

SELECT	BusinessEntityID,
		ShiftID
FROM	HumanResources.EmployeeDepartmentHistory
GROUP BY	BusinessEntityID, ShiftID;

SELECT	BusinessEntityID,
		ShiftID
FROM	HumanResources.EmployeeDepartmentHistory
GROUP BY	BusinessEntityID, ShiftID
HAVING	COUNT(BusinessEntityID + ShiftID) >= 2