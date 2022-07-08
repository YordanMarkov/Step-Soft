from fastapi import FastAPI, HTTPException, Request
import uvicorn
import pyodbc

from typing import Union
from pydantic import BaseModel
from fastapi.encoders import jsonable_encoder
from fastapi.templating import Jinja2Templates
from fastapi.responses import HTMLResponse

templates = Jinja2Templates(directory="Templates")

app = FastAPI()

sql_server = 'Driver={SQL Server};'\
             'Server=DESKTOP-1A39HCS\SQLEXPRESS;'\
             'Database=SUMC;'\
             'Trusted_Connection=yes;'

@app.get("/web/line/stops", response_class=HTMLResponse)
async def web_line_stops(request: Request):
    conn = pyodbc.connect(sql_server)
    cursor = conn.cursor()
    cursor.execute('SELECT ID, Type, Number FROM Lines ORDER BY ID')
    lines = []
    for row in cursor:
        lines.append({'id': int(row[0]), 'line': row[1]+str(row[2])})
    return templates.TemplateResponse("line_stops.html", {"request": request, "lines": lines})


@app.get("/Stops/Time/{line_id}/{way}")
async def given_line_way(line_id: int, way: bool):
    conn = pyodbc.connect(sql_server)
    cursor = conn.cursor()
    cursor.execute('SELECT l.Type, l.Number, s.Name, t.Time '+
                'FROM Lines l '+
                'LEFT JOIN Ways w ON w.Line_ID = l.ID '  +
                'LEFT JOIN Line_Stop ls ON ls.Line_ID = l.ID '+
                'LEFT JOIN Stops s ON ls.Stop_ID = s.ID '+
                'LEFT JOIN Schedules sc ON sc.Line_Stop_ID = ls.ID AND sc.Way_ID = w.ID '+
                'LEFT JOIN Times t ON t.Schedule_ID = sc.ID '+
                'WHERE l.ID = ' + str(line_id) + 'AND w.Way =' + str(int(way)) + '' +
                'GROUP BY l.Type, l.Number, s.Name, t.Time, ls.[Order], w.Way '+
                'ORDER BY '+
                    'CASE WHEN w.Way = 1 THEN ls.[Order] END ASC, '+
                    'CASE WHEN w.Way = 0 THEN ls.[Order] END DESC')
    data = []
    for row in cursor:
        data.append({'Type': str(row[0]), 'Number': int(row[1]), 'Name': str(row[2]), 'Time': str(row[3])})

    return {'lines': data}

@app.get("/Lines/{stop_id}")
async def given_stop(stop_id: int):
    conn = pyodbc.connect(sql_server)
    cursor = conn.cursor()
    cursor.execute('SELECT s.Name, l.Type, l.Number, t.Time \
                    FROM Stops s \
                    LEFT JOIN Line_Stop ls ON ls.Stop_ID = s.ID \
                    LEFT JOIN Lines l ON ls.Line_ID = l.ID \
                    LEFT JOIN Schedules sc ON sc.Line_Stop_ID = ls.ID \
                    LEFT JOIN Times t ON t.Schedule_ID = sc.ID \
                    WHERE s.ID =' + str(stop_id) + ' \
                    GROUP BY s.Name, l.Type, l.Number, t.Time, ls.[Order] \
                    ORDER BY t.Time asc')
    data = []
    for row in cursor:
        data.append({'Name': str(row[0]), 'Type': str(row[1]), 'Number': int(row[2]), 'Time': str(row[3])})

    return {'lines': data}

@app.get("/Time/{line_id}/{stop_id}/{way}")
async def given_line_stop_way(line_id: int, way: bool, stop_id: int):
    conn = pyodbc.connect(sql_server)
    cursor = conn.cursor()
    cursor.execute('SELECT l.Type, l.Number, s.Name, t.Time \
                    FROM Lines l \
                    LEFT JOIN Ways w ON w.Line_ID = l.ID \
                    LEFT JOIN Line_Stop ls ON ls.Line_ID = l.ID \
                    LEFT JOIN Stops s ON ls.Stop_ID = s.ID \
                    LEFT JOIN Schedules sc ON sc.Line_Stop_ID = ls.ID AND sc.Way_ID = w.ID \
                    LEFT JOIN Times t ON t.Schedule_ID = sc.ID \
                    WHERE l.ID = ' + str(line_id) + ' AND s.ID = ' + str(stop_id) + ' AND w.Way = ' + str(int(way)) + ' \
                    GROUP BY l.Type, l.Number, s.Name, t.Time, ls.[Order], w.Way \
                    ORDER BY \
                        CASE WHEN w.Way = 1 THEN ls.[Order] END ASC, \
                        CASE WHEN w.Way = 0 THEN ls.[Order] END DESC')
    data = []
    for row in cursor:
        data.append({'Type': str(row[0]), 'Number': str(row[1]), 'Name': str(row[2]), 'Time': str(row[3])})

    return {'lines': data}

@app.get("/Lines")
async def lines():
    conn = pyodbc.connect(sql_server)
    cursor = conn.cursor()
    cursor.execute('SELECT * FROM Lines')
    data = []
    for row in cursor:
        data.append({'ID': int(row[0]), 'Type': row[1], 'Number': int(row[2])})
    return {'lines': data}

@app.get("/Stops")
async def stops():
    conn = pyodbc.connect(sql_server)
    cursor = conn.cursor()
    cursor.execute('SELECT * FROM Stops')
    data = []
    for row in cursor:
        data.append({'ID': int(row[0]), 'Name': row[1]})
    return {'lines': data}

if __name__ == "__main__":
    uvicorn.run(app, host="127.0.0.1", port=8000)