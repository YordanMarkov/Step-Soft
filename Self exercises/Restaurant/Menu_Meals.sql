-- All meals for specific menu
SELECT me.Meal, me.[Quantity in grams], me.[Price in euro]
FROM Meals me
LEFT JOIN Menu_Meal mm ON me.ID = mm.Meal_ID
LEFT JOIN Menus m ON m.ID = mm.Menu_ID
WHERE m.ID = 1