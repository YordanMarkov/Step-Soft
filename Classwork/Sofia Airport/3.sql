--3)	Да се направи 2 информационни табла за едно летище – едното да е
--предстоящите излитания с час , дестинация, номер на терминал и гейт; 
--второто е за пристигащите – от къде , 
--в колко часа, евентуално закъснение, на кой термина и гейт.

-- Departures
SELECT f.Departure_Time + CAST(f.[Delay] as DATETIME) as "Taking off", f.EndDest, f.Terminal, f.Gate
FROM Flights f
WHERE f.StartDest = 'София';

-- Arrivals
SELECT f.Departure_Time + CAST(f.[Delay] as DATETIME) + 
CAST(f.Duration as DATETIME) as "Arriving at", 
f.StartDest, f.Terminal, f.Gate
FROM Flights f
WHERE f.EndDest = 'София';