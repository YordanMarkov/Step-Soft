
CREATE VIEW payment_total 
AS
SELECT p.Number, SUM(p.Total) as summary
FROM Payment p
GROUP BY p.Number;

SELECT s.Number, p.summary
FROM Sales s
LEFT JOIN payment_total p ON p.Number = s.Number
GROUP BY s.Number, p.summary;