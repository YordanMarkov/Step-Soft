ALTER PROCEDURE from_to (@StartDest varchar(50), @EndDest varchar(50), @isDirect bit, @Date date)
AS
BEGIN
	IF @isDirect = 1
		BEGIN
			SELECT f.ID, f.Departure_time,  
			SUM(p.Seats - f.Passengers) AS "Empty seats", f.Departure_Time + CAST(f.[Delay] as DATETIME) + 
			CAST(f.Duration as DATETIME), f.Price
			FROM Flights f
			LEFT JOIN Planes p ON f.Plane_ID = p.ID
			WHERE f.StartDest = @StartDest AND f.EndDest = @EndDest 
			AND @Date = CAST(f.Departure_time AS DATE)
			GROUP BY f.ID, f.Departure_time, f.Duration, f.Price, f.[Delay]
		END
	IF @isDirect = 0
		BEGIN
			--select 'pupesh'
		END
END