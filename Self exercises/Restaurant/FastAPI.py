from fastapi import FastAPI, HTTPException
import uvicorn
import pyodbc

app = FastAPI()

sql_server = 'Driver={SQL Server};'\
             'Server=DESKTOP-1A39HCS\SQLEXPRESS;'\
             'Database=Restaurant;'\
             'Trusted_Connection=yes;'

@app.get("/MenuItems/{menu_id}")
async def menu(menu_id: int):
    conn = pyodbc.connect(sql_server)
    cursor = conn.cursor()
    cursor.execute('SELECT me.Meal, me.[Quantity in grams], me.[Price in euro] ' +
                   'FROM Meals me ' +
                   'LEFT JOIN Menu_Meal mm ON me.ID = mm.Meal_ID ' +
                   'LEFT JOIN Menus m ON m.ID = mm.Menu_ID ' +
                   'WHERE m.ID =' + str(menu_id))
    data = []
    for row in cursor:
        data.append({'Meal': str(row[0]), 'Quantity in grams': int(row[1]), 'Price in euro': float(row[2])})

    return {'lines': data}

if __name__ == "__main__":
    uvicorn.run(app, host="127.0.0.1", port=8000)