ALTER PROCEDURE from_to (@StartDest int, @EndDest int, @isDirect bit, @Date date)
AS
BEGIN
	IF @isDirect = 1
		BEGIN
			SELECT f.ID, f.Departure_time,  
			SUM(p.Seats - f.Passengers) AS "Empty seats", f.Departure_Time + CAST(f.[Delay] as DATETIME) + 
			CAST(f.Duration as DATETIME), f.Price
			FROM Flights f
			LEFT JOIN Planes p ON f.Plane_ID = p.ID
			WHERE f.StartDest_ID = @StartDest AND f.EndDest_ID = @EndDest 
			AND @Date = CAST(f.Departure_time AS DATE)
			GROUP BY f.ID, f.Departure_time, f.Duration, f.Price, f.[Delay]
		END
	IF @isDirect = 0
		BEGIN
			SELECT f.ID, f.Departure_time,  
			SUM(p.Seats - f.Passengers) AS "Empty seats", f.Departure_Time + CAST(f.[Delay] as DATETIME) + 
			CAST(f.Duration as DATETIME), f.Price
			FROM Flights f
			LEFT JOIN Planes p ON f.Plane_ID = p.ID
			LEFT JOIN Direction d ON d.[From] = f.StartDest_ID
			LEFT JOIN Flights f2 ON d.[To] = f2.StartDest_ID
			WHERE @Date = CAST(f.Departure_time AS DATE) 
			GROUP BY f.ID, f.Departure_time, f.Duration, f.Price, f.[Delay]
		END
END

EXEC from_to 1, 6, 0, '2022-07-12'
