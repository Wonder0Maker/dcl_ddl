
CREATE DATABASE TestDb;
GO

CREATE SCHEMA TestSchema;
GO

CREATE TABLE TestTable(		Id			INT NOT NULL,
							Name 		VARCHAR(20),
							IsSold		BIT,
							InvoiceDate	DATE	);
GO

INSERT INTO TestTable
VALUES	(1,	'Boat',		1,	'2020-11-08'),
		(2,	'Auto',		0,	'2020-11-09'),
		(3,	'Plane',	null,	'2020-12-09');
GO

USE TestDb;
GO
EXEC sp_configure 'CONTAINED DATABASE AUTHENTICATION', 1;
GO
RECONFIGURE;
GO
USE [master]
GO
ALTER DATABASE TestDb SET CONTAINMENT = PARTIAL;
GO

CREATE LOGIN TestUser 
	WITH PASSWORD = 'MandrykA1608';
USE TestDb;
GO
CREATE USER TestUser FOR LOGIN TestUser;
GO

GRANT CONNECT ON DATABASE::TestDb TO TestUser;
GO
EXECUTE AS USER = 'TestUser';
GO
SELECT	CURRENT_USER;
GO


REVERT;
GO
SELECT	CURRENT_USER;
GO

USE TestDb;
GO
SELECT	* 
FROM	TestTable;
GO

GRANT SELECT ON OBJECT::TestTable TO TestUser;
GO
EXECUTE AS USER = 'TestUser';
GO

USE TestDb;
GO
SELECT	* 
FROM	TestTable;
GO

REVERT;
GO
DROP USER TestUser;
