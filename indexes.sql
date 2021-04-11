USE TestDB;
GO
------------------------------------------------
-- Query 1
CREATE TABLE	dbo.Customer
(		CustomerID	INT NOT NULL,
		FirstName	VARCHAR(50),
		LastName	VARCHAR(50),
		Email	VARCHAR(100),
		ModifiedDate	DATE,
		CONSTRAINT PK_Customer_CustomerID	
			PRIMARY KEY CLUSTERED (CustomerID)
);
GO
------------------------------------------------
-- Query 2
CREATE NONCLUSTERED INDEX IX_Customer_FirstName_LastName
	ON dbo.Customer
(
		FirstName ASC,
		LastName ASC
);
GO
------------------------------------------------
-- Query 3
CREATE INDEX IX_Customer_ModifiedDate 
	ON dbo.Customer (ModifiedDate)
	INCLUDE (FirstName, LastName);
GO

SELECT FirstName
,LastName
FROM dbo.Customer
WHERE ModifiedDate = '2020-10-20';GO------------------------------------------------
-- Query 4CREATE TABLE dbo.Customer2
(		CustomerID	INT,
		AccountNumber	VARCHAR(10)
			CONSTRAINT CI_Customer_ID
				PRIMARY KEY CLUSTERED (CustomerID),		
		FirstName	VARCHAR(50),
		LastName	VARCHAR(50),
		Email	VARCHAR(100),
		ModifiedDate	DATE,
);
GO
-- DROP TABLE dbo.Customer2
------------------------------------------------
-- Query 5
EXEC SP_RENAME 
	N'dbo.Customer2.CI_Customer_ID', 
	N'CI_CustomerID',
	N'INDEX'; 
GO
------------------------------------------------
-- Query 6
ALTER TABLE dbo.Customer2
DROP CONSTRAINT CI_CustomerID 
------------------------------------------------
-- Query 7
CREATE UNIQUE NONCLUSTERED INDEX AK_Customer_Email
	ON dbo.Customer2 (Email);
GO
------------------------------------------------
-- Query 8
CREATE NONCLUSTERED INDEX IX_Customer2_ModifiedDate
	ON dbo.Customer2 (ModifiedDate)
	WITH (FILLFACTOR = 70);
GO

