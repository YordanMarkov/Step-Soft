import json
import pyodbc

sql_server = 'Driver={SQL Server};'\
             'Server=DESKTOP-1A39HCS\SQLEXPRESS;'\
             'Database=SofBus;'\
             'Trusted_Connection=yes;'

with open('metro_lines.json', encoding='utf-8') as f:
    metro_lines = json.load(f)

for line, stops in metro_lines.items():
    print(line, stops)

conn = pyodbc.connect(sql_server)
cursor = conn.cursor()

def check(line):
    result = cursor.execute("SELECT ID FROM dbo.BusLines WHERE Lines='{}'".format(line))
    line_id = None
    result_rows = result.fetchall()
    if len(result_rows) > 0:
        line_id = result_rows[0][0]
    return line_id

for line, stops in metro_lines.items():
    # result = cursor.execute("SELECT ID FROM dbo.BusLines WHERE Lines='{}'".format(line))
    # line_id = None
    # result_rows = result.fetchall()
    # if len(result_rows) > 0:
    #     line_id = result_rows[0][0]
    line_id = check(line)
    if line_id is None:
        cursor.execute("INSERT INTO dbo.BusLines(Lines) VALUES ('{}')".format(line))
        conn.commit()