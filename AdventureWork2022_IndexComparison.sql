USE AdventureWorksDW2022;

-- HEAP
SELECT * 
INTO FactInternetSales_HP
FROM FactInternetSales;

-- RowStore
SELECT * 
INTO FactInternetSales_RS
FROM FactInternetSales;

CREATE CLUSTERED INDEX idx_FactInternetSales_RS_PK ON FactInternetSales_RS (SalesOrderNumber, SalesOrderLineNumber);


-- ColumnStore
SELECT * 
INTO FactInternetSales_CS
FROM FactInternetSales;

CREATE CLUSTERED COLUMNSTORE INDEX idx_FactInternetSales_CS_PK ON FactInternetSales_CS;



/*

*/

SELECT
	fs.SalesOrderNumber,
	dp.EnglishProductName,
	dp.Color
FROM FactInternetSales fs
INNER JOIN Dimproduct dp
	ON fs.productKey = dp.ProductKey
WHERE dp.color = 'Black'
AND fs.OrderDateKey BETWEEN 20101229 AND 20101231;
