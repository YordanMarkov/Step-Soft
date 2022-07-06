SELECT b.Lines as "Line", 
	   s.[Stop], 
	   l.Stop_Num as "Order"
FROM BusLines b 
LEFT JOIN Line_Stop l ON b.ID = l.Line_ID
LEFT JOIN Stops s ON s.ID = l.Stop_ID
WHERE b.ID = 1
ORDER BY l.Stop_Num ASC;