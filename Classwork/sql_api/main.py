import pyodbc

sql_server = 'Driver={SQL Server};'\
             'Server=DESKTOP-1A39HCS\SQLEXPRESS;'\
             'Database=SofBus;'\
             'Trusted_Connection=yes;'

conn = pyodbc.connect(sql_server)

cursor = conn.cursor()
cursor.execute('SELECT * FROM dbo.Line_Stop')

for i in cursor:
    print(i)