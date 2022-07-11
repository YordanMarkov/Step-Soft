USE SofBus
DELETE FROM Stops WHERE Stops.ID = Line_Stop.Stop_ID

ALTER PROCEDURE delete_stops (@id int)
AS
BEGIN
    DELETE FROM Stops WHERE Stops.ID = @id
END

ALTER PROCEDURE delete_line_stop_conn (@id int)
AS
BEGIN
    DECLARE @stop int = (SELECT Stop_ID FROM Line_Stop WHERE Line_ID = @id)
    EXEC delete_stops @stop
    DELETE FROM Line_Stop WHERE Line_ID = @id
END

ALTER PROCEDURE delete_line (@line_id int)
AS
BEGIN
    DECLARE @ID int = (SELECT ID FROM BusLines WHERE BusLines.ID = @line_id)
    DECLARE @result int = (SELECT COUNT(*) FROM Line_Stop WHERE Line_ID = @line_id)
    IF @result = 0
        BEGIN
            DELETE FROM BusLines WHERE BusLines.ID = @line_id
            SELECT 'Successful delete!'
        END
    IF @result > 0
        BEGIN
            DELETE FROM BusLines WHERE BusLines.ID = @line_id
            EXEC delete_line_stop_conn @line_id
            SELECT 'Successful line & stops delete!'
        END
END

SELECT * FROM BusLines

SELECT * FROM Stops

SELECT * FROM Line_Stop

EXEC delete_line 1