USE	TestDb;
GO

INSERT INTO	TestSchema.TestTable
VALUES	
	(4, 'Bicycle', 0, '2020-08-23'),
	(5, 'Rocket', 1, '2020-01-01'),
	(6, 'Motocycle', null, '2020-08-26'),
	(7, 'Submarine', 0, '1999-05-16');
GO

INSERT INTO	TestSchema.TestTable (id, InvoiceDate)
VALUES	(8, '2020-08-25');
GO

INSERT INTO	TestSchema.TestTable (id, Name)
VALUES	(8, 'Scooter');
GO

UPDATE	TestSchema.TestTable
SET	IsSold = 0
WHERE	IsSold IS NULL ;
GO

DELETE FROM	TestSchema.TestTable
WHERE NAME IS NULL OR InvoiceDate IS NULL;
GO

CREATE TABLE TestSchema.TestTable2 (
	Id INT NOT NULL
	,Name VARCHAR(20)
	,IsSold BIT
	,InvoiceDate DATE
	);
GO

INSERT INTO TestSchema.TestTable2
VALUES
	(1, 'Speed Boat', 1, '2020-11-08')
	,(7, 'Submarine', 0, '1999-05-16')
	,(8, 'Segway', 1, '2021-01-01');
GO

MERGE	TestSchema.TestTable as Base
USING	TestSchema.TestTable2 as Source
ON	(Base.id = Source.id)
WHEN MATCHED AND Base.Name != Source.Name 
	THEN UPDATE SET	Base.name = Source.name,
			Base.IsSold = Source.IsSold,
			Base.InvoiceDate = Source.InvoiceDate
WHEN NOT MATCHED
	THEN INSERT	(id, Name, IsSold, InvoiceDate)
	VALUES	(Source.id, Source.Name, 
		Source.IsSold, Source.InvoiceDate);
GO
		

