/*
	INDEX
		- Data structure provides quick access to data, optimizing the speed of your queries.

	Types of indexes
		- Structure Index
			- Clustered Index
			- Non-Clustered Index

		- Storage based
			- Rowstore Index
			- Columnstore Index

		- Functions based
			- Unique Index
			- Filtered Index
*/


/*
	Data in SQL is stored in DataFile (.mdf)
		- This file contains pages where data is actually stored

	PAGE
		- The smallest unit of data storage in a database (8kb)
		- It stores anything (Data, Metadata, Indexes, etc.)
			Types:
			- Data Page
			- Index Page

		- Page has a header, data and offset array

	HEAP: Table WITHOUT Clustered Index
	Table Full Scan: Scans the entire table page by page and row by row, searching for data.
*/

/*
	Clustered Index
		- SQL sorts all the data based on indexed column
		- Creates a B-tree(Balance Tree): Hierarchical structure storing data at leaves, to help quickly locate data.
		- All the data is stored in leaf 
		- Intermediate nodes has INDEX PAGE: It stores key values (Pointers) to another page. It doesn't store the actual rows.
	

	Non-Clustered Index
		- A non-clugtered index won't reorqanize or chanqe anythnq on the data page
		- Here also SQL creates index page, but using RID (Row Identifier), it has 2 info, page header and offset to find the exact location of record

	You can only create one Clusered Index per table (beacuse data can be sorted by one order only)
		- Clustered Index is faster, but write performance is slower


	CREATE [CLUSTERED | NONCLUSTERED) INDEX index_name ON table_name (column1, column2 .......)
*/

SELECT *
FROM Sales.DBCustomers
WHERE CustomerID = 1;

CREATE CLUSTERED INDEX idx_DBCustomers_CustomerID ON Sales.DBCustomers (CustomerID);


DROP INDEX idx_DBCustomers_CustomerID ON Sales.DBCustomers;


CREATE NONCLUSTERED INDEX idx_DBCustomers_LastName ON Sales.DBCustomers (LastName);

CREATE INDEX idx_DBCustomers_FirstName ON Sales.DBCustomers (FirstName);

CREATE INDEX idx_DBCustomers_CountryScore ON Sales.DBCustomers (Country, Score);

/*
	Leftmost Prefix Rule
		- Index works only if your query filters start from the first column in the index and follow its order.

	Columns - A,B,C,D

		Index will be used
		A
		A,B
		A,B,C
		
		Index won't be used
		B
		A,C
		A,B,D
*/


/*
	Rowstore Index = Stores the data row-by-row in pages
		- High frequency transaction applications
		- Quick access to complete records
		- Lower I/O efficiency
		- Less efficient in Storage
		- Fair speed for read/write operations

	Columnstore Index = Stored the data column-by-column in pages
		- Big Data Analytics
		- Scanning of large datasets
		- Fast aggregation
		- Higher I/O efficiency
		- High efficient in storage eith compression
		- Fast read performance, slow write performance
		- CREATE [CLUSTERED | NONCLUSTERED] [COLUMNSTORE] INDEX index_name ON table name (column1, column2, .........)
		- If COLUMNSTORE not written, its ROWSTORE by default

	- YOu can't specify columns in Clusterd index columnstore
	- You can only create one COLUMNSTORE index for each table
*/

/*
	If Clustered Columnstore index is used - Original table will be deleted and the new columnstore process index is stored only
	But if NonClustered Columnstore index is used - Original table will be exist side by side with the new columnstore process index is stored only
*/

SELECT CASE NULL
  WHEN NULL THEN 'Equal'
  ELSE 'Not Equal'
END;


CREATE CLUSTERED COLUMNSTORE INDEX idx_DBCustommers_CS ON Sales.DBCustomers;

CREATE NONCLUSTERED COLUMNSTORE INDEX idx_DBCustommers_CS_FirstName ON Sales.DBCustomers (FirstName);


DROP INDEX [idx_DBCustomers_CustomerID] ON Sales.DBCustomers;


/*
	Unique Index
		- Ensures no duplicate values exist in specific column.
		- Benefits
			1. Enforce uniqueness
			2. Slightly increase query perfromance

		- Writing to an unique index is slower.than non-unique.
		- Reading from an unique index is faster than non-unique.
		- CREATE [UNIQUE] [CLUSTERED | NONCLUSTERED] [COLUMNSTORE] INDEX index_name ON table_name (Column1 , Column2,...)

		-- If there are duplicate values in the column, Unique index cannot be created
*/

SELECT * FROM Sales.Products;

CREATE UNIQUE NONCLUSTERED INDEX idx_Products_Product ON Sales.Products (Product);

INSERT INTO Sales.Products (ProductID, Product) VALUES (106, 'Caps');


/*
	Filtered Index
		- An index that includes only rows meeting the specified conditions
		- Helps in Targeted Ootimization
		- Reduced Storage: Less data in index pages
		- CREATE [UNIQUE] [NONCLUSTERED] INDEX index name
			ON table_name (column1, column2, ....)
			WHERE [Condition]

		- You cannot create a filtered index on a clustered index.
		- You cannot create a filtered index on a columnstore index.

*/

SELECT * FROM Sales.Customers
WHERE Country = 'USA';

CREATE NONCLUSTERED INDEX idx_Customers_USA ON Sales.Customers (Country) WHERE Country = 'USA'


/*
	When to USE

	HEAP
		- Fast Inserts
	
	Clustered Index
		- For Primary Keys
		- If not, then for Date columns

	Non-Clustered Index
		- For Non-PK columns (Foreign keys, Joins and Filters)

	Columnstore Index
		- For Analytical Queries
		- Reduce Size of Large Table

	
	Filtered Index
		- Target Subset of Data
		- Reduce Size of Index

	Unique Index
		- Enforce Uniqueness
		- Improve Query Speed

*/

/*
	Index Management
		- Monitor Index Usage
		- Monitor Missing Indexes
		- Monitor Duplicate Indexes
		- Update Statistics
		- Monitor Fragmentation
*/

-- List all the indexes on a specific table
sp_helpindex 'Sales.DBCustomers';

/*
	Monitor Index Usage
	
	'Sys' System Schema
		- contains metadata about database tables, views, indexes..etc
*/

-- See all indexes
SELECT * FROM sys.indexes;

-- See all tables
SELECT * FROM sys.tables;


-- See all indexes on our tables
SELECT
	tbl.name AS TableName,
	idx.name AS IndexName,
	idx.type_desc AS IndexType,
	idx.is_primary_key AS IsPrimaryKey,
	idx.is_unique AS IsUnique,
	idx.is_disabled AS IsDisabled
FROM sys.indexes as idx
JOIN sys.tables as tbl
	ON idx.object_id = tbl.object_id
ORDER BY tbl.name, idx.name;

/*
	Dynamic Management View (DMV)
		- provides real-time insights into Database performance and system health
*/
SELECT * FROM sys.dm_db_index_usage_stats;

SELECT
	tbl.name AS TableName,
	idx.name AS IndexName,
	idx.type_desc AS IndexType,
	idx.is_primary_key AS IsPrimaryKey,
	idx.is_unique AS IsUnique,
	idx.is_disabled AS IsDisabled,
	s.user_seeks AS UserSeeks,
	s.user_scans AS UserScans,
	s.user_lookups AS UserLookups,
	s.user_updates AS UserUpdates,
	COALESCE(s.last_user_seek, s.last_user_scan) LastUpdate
FROM sys.indexes as idx
JOIN sys.tables as tbl
	ON idx.object_id = tbl.object_id
LEFT JOIN sys.dm_db_index_usage_stats s
	ON s.object_id = idx.object_id
	AND s.index_id = idx.index_id
ORDER BY tbl.name, idx.name;



/*
	Monitor Missing Indexes

*/

SELECT * FROM sys.dm_db_missing_index_details;


/*
	Monitoring duplicate indexes
*/

SELECT
	idx.name as IndexName,
	tbl.name as TableName,
	col.name as IndexColumn,
	idx.type_desc as IndexType,
	COUNT(*) OVER(PARTITION BY tbl.name, col.name) ColumnCount
FROM sys.indexes as idx
JOIN sys.tables as tbl
	ON idx.object_id = tbl.object_id
JOIN sys.index_columns as ic
	ON idx.object_id = ic.object_id AND idx.index_id = ic.index_id
JOIN sys.columns as col
	ON ic.object_id = col.object_id AND ic.column_id = col.column_id
ORDER BY tbl.name, col.name;


/*
	Updating Statistics
	- there is one table in db, which stores info like how many rows are there in each table and all. so whenever we fire a query, it fetch some metadata related that table, to create an execution plan. 
	- But sometime what happen is, the statistics table is not updated and because of old data, execution plan might not be the best. 
	- so we have to check if the statistics table is up to date, if not update it
*/

-- see when the last time a statistics was updated
SELECT
	SCHEMA_NAME(t.schema_id) AS SchemaName,
	t.name AS TableName,
	s.name AS StatisticName,
	sp.last_updated AS LastUpdate,
	DATEDIFF(day, sp.last_updated, GETDATE()) As LastUpdateDay,
	sp.rows AS 'Rows',
	sp.modification_counter AS ModificationsSinceLastUpdate
FROM sys.stats AS s
JOIN sys.tables t
	ON s.object_id = t.object_id
CROSS APPLY sys.dm_db_stats_properties(s.object_id, s.stats_id) AS sp
ORDER BY
sp.modification_counter DESC;


-- update statistics
UPDATE STATISTICS Sales.Products _WA_Sys_00000004_398D8EEE;

-- update for all
UPDATE STATISTICS Sales.Products;

-- alternative way for all database updateion
EXEC sp_updatestats



/*
	Monitor Index Fragmentations
		- Unused spaces in data pages
		- Data pages are out of order

	Fragmentation Methods
		Reorganize
		- Defragments leaf nodes to keep them sorted
		- "Light" Operation
		Rebuild
		- Recreates Index from Scratch
		- "Heavy" Operation

*/

/*
	Indicate how out-of-order pages are within the index
		- 0% means no fragmentation (perfect)
		- 100% means index is completely fragmented (out of order)

	When to Defragment?
		<10% - No Action needed
		10-30% - Reorganize
		>30% - Rebuild
*/

SELECT 
	tbl.name AS TableName,
	idx.name AS IndexName,
	s.avg_fragmentation_in_percent,
	s.page_count
FROM sys.dm_db_index_physical_stats(DB_ID(), NULL, NULL, NULL, 'LIMITED') AS s
JOIN sys.tables tbl
	ON s.object_id = tbl.object_id
INNER JOIN sys.indexes as idx
	ON idx.index_id = s.index_id
ORDER BY s.avg_fragmentation_in_percent DESC;


-- REORGANIZE
ALTER INDEX idx_Customer_CS_USA ON Sales.Customers REORGANIZE;

-- REBUILD
ALTER INDEX idx_Customer_USA ON Sales.Customers REBUILD;
