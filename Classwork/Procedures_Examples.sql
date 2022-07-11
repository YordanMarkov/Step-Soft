-- Ќомер на доктор -> време колко е работил
ALTER PROCEDURE doc_time(@ID_Doctor int)
AS
BEGIN
	SELECT CAST(StartDate as Date) as [Day],
	SUM(DATEDIFF(MINUTE, StartDate, EndDate))  over (partition by ID_Doctor order by StartDate) as [Minutes]
	FROM Pregledi WHERE ID_Doctor = @ID_Doctor
	--GROUP BY CAST(StartDate as Date)
END

EXEC doc_time 1

SELECT *
FROM Pregledi
WHERE StartDate >= DATEADD(DD, -2, GETDATE())