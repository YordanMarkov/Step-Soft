from fastapi import FastAPI, HTTPException
import uvicorn
import pyodbc

from typing import Union
from pydantic import BaseModel
from fastapi.encoders import jsonable_encoder

class Line(BaseModel):
    line: Union[str, None] = None

class Stop(BaseModel):
    stop: Union[str, None] = None

app = FastAPI()

sql_server = 'Driver={SQL Server};'\
             'Server=DESKTOP-1A39HCS\SQLEXPRESS;'\
             'Database=SofBus;'\
             'Trusted_Connection=yes;'

@app.get("/lines")
async def lines():
    conn = pyodbc.connect(sql_server)
    cursor = conn.cursor()
    cursor.execute('SELECT * FROM dbo.BusLines')
    data = []
    for row in cursor:
        data.append({'id': int(row[0]), 'line': row[1]})

    return {'lines': data}

@app.get("/stops")
async def stops():
    conn = pyodbc.connect(sql_server)
    cursor = conn.cursor()
    cursor.execute('SELECT * FROM dbo.Stops')
    data = []
    for row in cursor:
        data.append({'id': int(row[0]), 'line': row[1]})
    return {'lines': data}

@app.get("/stops/line/{line_id}")
async def read_item(line_id: int):
    conn = pyodbc.connect(sql_server)
    cursor = conn.cursor()
    cursor.execute('SELECT b.Lines as "Line", s.[Stop], l.Stop_Num as "Order" FROM BusLines b LEFT JOIN Line_Stop l ON b.ID = l.Line_ID LEFT JOIN Stops s ON s.ID = l.Stop_ID WHERE b.ID = '+ str(line_id) + 'ORDER BY l.Stop_Num ASC;')
    data = []
    for row in cursor:
        if row[2] == None:
            raise HTTPException(status_code=404, detail="Item not found.")
        data.append({'Line': row[0], 'Stop': row[1], 'Order': int(row[2])})

    return {'lines': data}

@app.put("/lines", response_model=Line)
async def put_line(line: Line):
    data = jsonable_encoder(line)
    conn = pyodbc.connect(sql_server)
    cursor = conn.cursor()
    cursor.execute('INSERT INTO dbo.BusLines(Lines) VALUES (\'' + line.line + '\')')
    conn.commit()
    return data

@app.put("/stops", response_model=Stop)
async def put_stop(stop: Stop):
    data = jsonable_encoder(stop)
    conn = pyodbc.connect(sql_server)
    cursor = conn.cursor()
    cursor.execute('INSERT INTO dbo.Stops(Stop) VALUES (\'' + stop.stop + '\')')
    conn.commit()
    return data




if __name__ == "__main__":
    uvicorn.run(app, host="127.0.0.1", port=8000)