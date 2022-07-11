SELECT l.Type, l.Number, s.Name, t.Time
FROM Lines l
LEFT JOIN Ways w ON w.Line_ID = l.ID
LEFT JOIN Line_Stop ls ON ls.Line_ID = l.ID
LEFT JOIN Stops s ON ls.Stop_ID = s.ID
LEFT JOIN Schedules sc ON sc.Line_Stop_ID = ls.ID AND sc.Way_ID = w.ID
LEFT JOIN Times t ON t.Schedule_ID = sc.ID
WHERE l.ID = 1 AND w.Way = 0
GROUP BY l.Type, l.Number, s.Name, t.Time, ls.[Order], w.Way
ORDER BY 
    CASE WHEN w.Way = 1 THEN ls.[Order] END ASC, 
    CASE WHEN w.Way = 0 THEN ls.[Order] END DESC

-- Заявка 2: Да се изкарат всички превозни средства, спиращи на дадена спирка, по час↑

SELECT s.Name, l.Type, l.Number, t.Time
FROM Stops s
LEFT JOIN Line_Stop ls ON ls.Stop_ID = s.ID
LEFT JOIN Lines l ON ls.Line_ID = l.ID
LEFT JOIN Schedules sc ON sc.Line_Stop_ID = ls.ID
LEFT JOIN Times t ON t.Schedule_ID = sc.ID
WHERE s.ID = 4
GROUP BY s.Name, l.Type, l.Number, t.Time, ls.[Order]
ORDER BY t.Time asc

-- Заявка 3: Да се изкарат всички часове↑ за дадена линия, дадена спирка и даден път

SELECT l.Type, l.Number, s.Name, t.Time
FROM Lines l
LEFT JOIN Ways w ON w.Line_ID = l.ID
LEFT JOIN Line_Stop ls ON ls.Line_ID = l.ID
LEFT JOIN Stops s ON ls.Stop_ID = s.ID
LEFT JOIN Schedules sc ON sc.Line_Stop_ID = ls.ID AND sc.Way_ID = w.ID
LEFT JOIN Times t ON t.Schedule_ID = sc.ID
WHERE l.ID = 1 AND s.ID = 1 AND w.Way = 0
GROUP BY l.Type, l.Number, s.Name, t.Time, ls.[Order], w.Way
ORDER BY 
    CASE WHEN w.Way = 1 THEN ls.[Order] END ASC, 
    CASE WHEN w.Way = 0 THEN ls.[Order] END DESC


--SELECT 
--Schedule_ID, COUNT(*)
--FROM Times 
--GROUP BY Schedule_ID
--HAVING COUNT(*) > 1


--SELECT l.Type, l.Number, s1.Name, s2.Name
--FROM Lines l
--LEFT JOIN (SELECT Stop_ID, MIN([Order]) as First, MAX([Order]) as Last FROM Line_Stop
--GROUP BY Stop_ID) as FL ON FL.Stop_ID = l.ID
--LEFT JOIN Stops s1 ON FL.First = s1.ID
--LEFT JOIN Stops s2 ON FL.Last = s2.ID
--GROUP BY l.Type, l.Number, s1.Name, s2.Name


--SELECT ls1.Line_ID, ls1.Stop_ID, ls2.Stop_ID
--FROM Line_Stop ls1
--LEFT JOIN Line_Stop ls2 ON ls1.ID = ls2.ID
--LEFT JOIN(SELECT Line_ID, Stop_ID, [Order]
--FROM Line_Stop) AS St ON St.Line_ID = ls1.Line_ID
--GROUP BY ls1.Line_ID, ls1.[Order], ls2.[Order], ls1.Stop_ID, ls2.Stop_ID
--HAVING MIN(St.[Order]) = ls1.[Order] AND MAX(St.[Order]) = ls2.[Order]

--SELECT Line_ID, Stop_ID, [Order]
--FROM Line_Stop
--GROUP BY Line_ID, Stop_ID, [Order]
--HAVING MAX([Order]) = 3

--SELECT Line_ID, Stop_ID, [Order]
--FROM Line_Stop

SELECT l.Type, l.Number, MIN([ORDER]) as 'Първа спирка:', MAX([ORDER]) as 'Последна спирка:' 
FROM lines l 
LEFT JOIN Line_Stop ls ON ls.Line_ID = l.ID
LEFT JOIN Stops s ON s.ID = ls.Stop_ID
LEFT JOIN Ways w ON w.Line_ID = l.ID
LEFT JOIN Schedules sc ON sc.Line_Stop_ID = ls.ID AND sc.Way_ID = w.ID
GROUP BY l.Type, l.Number

-- Първа и последна спирка
SELECT l.Type, l.Number, s1.Name, s2.Name
FROM Lines l
LEFT JOIN Line_Stop ls ON l.ID = ls.Line_ID
LEFT JOIN (SELECT l.Type, l.Number, MIN([ORDER]) as 'Първа спирка:', MAX([ORDER]) as 'Последна спирка:' 
			FROM lines l 
			LEFT JOIN Line_Stop ls ON ls.Line_ID = l.ID
			LEFT JOIN Stops s ON s.ID = ls.Stop_ID
			LEFT JOIN Ways w ON w.Line_ID = l.ID
			LEFT JOIN Schedules sc ON sc.Line_Stop_ID = ls.ID AND sc.Way_ID = w.ID
			GROUP BY l.Type, l.Number) as FL ON FL.Number = l.Number AND FL.Type = l.Type
LEFT JOIN Stops s1 ON s1.ID = ls.Stop_ID AND ls.[Order] = FL.[Първа спирка:]
LEFT JOIN Stops s2 ON s2.ID = ls.Stop_ID AND ls.[Order] = FL.[Последна спирка:]
--GROUP BY l.ID, l.Type, l.Number, s1.Name, s2.Name