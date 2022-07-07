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