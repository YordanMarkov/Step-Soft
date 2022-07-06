-- Every Menu's total price, grams
SELECT m.[Menu type], SUM(me.[Price in euro]) as "Price", SUM(me.[Quantity in grams]) as "Total weight in grams"
FROM Menus m
LEFT JOIN Menu_Meal mm ON mm.Menu_ID = m.ID
LEFT JOIN Meals me ON mm.Meal_ID = me.ID
GROUP BY m.[Menu type]