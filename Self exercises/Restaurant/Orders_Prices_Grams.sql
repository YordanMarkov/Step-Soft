-- Every Order's total price, grams
SELECT o.[Order Number], SUM(me.[Price in euro]) as "Price", SUM(me.[Quantity in grams]) as "Total weight in grams"
FROM [Order] o
LEFT JOIN Menus m ON m.ID = o.Menu_ID
LEFT JOIN Meals me ON o.Meal_ID = me.ID
GROUP BY o.[Order Number]