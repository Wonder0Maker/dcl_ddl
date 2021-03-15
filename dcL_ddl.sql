
CREATE DATABASE TestDb;
GO

USE TestDb;
GO
CREATE SCHEMA TestSchema;
GO

CREATE TABLE TestSchema.TestTable(		Id			INT NOT NULL,
										Name		VARCHAR(20),
										IsSold		BIT,
										InvoiceDate DATE	);
GO

INSERT INTO TestSchema.TestTable
VALUES	(1,	'Boat',		1,		'2020-11-08'),
		(2,	'Auto',		0,		'2020-11-09'),
		(3,	'Plane',	null,	'2020-12-09');
GO

EXEC sp_configure 'CONTAINED DATABASE AUTHENTICATION', 1;
GO
RECONFIGURE;
GO
USE TestDb;
GO
ALTER DATABASE TestDb SET CONTAINMENT = PARTIAL;
GO

CREATE USER TestUser WITHOUT LOGIN;
GO

GRANT CONNECT TO TestUser;
GO
EXECUTE AS USER = 'TestUser';
GO
SELECT	* 
FROM	TestSchema.TestTable;
GO

REVERT;
GO
SELECT	CURRENT_USER;
GO

SELECT	* 
FROM	TestSchema.TestTable;
GO

GRANT SELECT TO TestUser;
GO
EXECUTE AS USER = 'TestUser';
GO

SELECT	* 
FROM	TestSchema.TestTable;
GO

REVERT;
GO
DROP USER TestUser;