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
def check_line(line):
    result = cursor.execute("SELECT ID FROM dbo.BusLines WHERE Lines='{}'".format(line))
    line_id = None
    result_rows = result.fetchall()
    if len(result_rows) > 0:
        line_id = result_rows[0][0]
    return line_id

def check(stop):
    result = cursor.execute("SELECT ID FROM dbo.Stops WHERE Stop='{}'".format(stop))
    stop_id = None
    result_rows = result.fetchall()
    if len(result_rows) > 0:
        stop_id = result_rows[0][0]
    return stop_id

def check_line_stop(stop_id, line_id):
    result = cursor.execute("SELECT ID FROM dbo.Line_Stop WHERE Stop_ID='{}' AND Line_ID='{}'".format(stop_id, line_id))
    result_rows = result.fetchall()
    if len(result_rows) == 0:
        return True
    else:
        return False

for line, stops in metro_lines.items():
    stop_counter = 0
    for i in stops:
        stop_counter += 1
        stop_id = check(i)
        if stop_id is None:
            cursor.execute("INSERT INTO dbo.Stops(Stop) VALUES ('{}')".format(i))
            conn.commit()
        line_id = check_line(line)
        stop_id = check(i)
        if check_line_stop(stop_id, line_id):
            cursor.execute("INSERT INTO dbo.Line_Stop(Line_ID, Stop_ID, Stop_Num) VALUES ('{}', '{}', '{}')".format(line_id, stop_id, stop_counter))
            conn.commit()