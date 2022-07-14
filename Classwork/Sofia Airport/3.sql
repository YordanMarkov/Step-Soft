--3)	Да се направи 2 информационни табла за едно летище – едното да е
--предстоящите излитания с час , дестинация, номер на терминал и гейт; 
--второто е за пристигащите – от къде , 
--в колко часа, евентуално закъснение, на кой термина и гейт.
ALTER PROCEDURE Departures(@id int)
AS
BEGIN
	-- Departures
	SELECT f.Departure_Time + CAST(f.[Delay] as DATETIME) as "Taking off", A.[Name], f.Terminal, f.Gate
	FROM Flights f
	LEFT JOIN Airports A ON A.ID = f.EndDest_ID
	LEFT JOIN Airports A2 ON A2.ID = f.StartDest_ID
	WHERE A2.ID = @id;
END

ALTER PROCEDURE Arrivals(@id int)
AS
BEGIN
	-- Arrivals
	SELECT f.Departure_Time + CAST(f.[Delay] as DATETIME) + 
	CAST(f.Duration as DATETIME) as "Arriving at", 
	A.[Name], f.Terminal, f.Gate
	FROM Flights f
	LEFT JOIN Airports A ON A.ID = f.StartDest_ID
	LEFT JOIN Airports A2 ON A2.ID = f.EndDest_ID
	WHERE A.ID = @id;
END

EXEC Departures 2
EXEC Arrivals 2