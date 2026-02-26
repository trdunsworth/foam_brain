USE Reporting_System;
GO

-- Create inline function for parsing elapsed time strings
IF OBJECT_ID('dbo.fn_ParseElapsedTime') IS NOT NULL
    DROP FUNCTION dbo.fn_ParseElapsedTime;
GO

CREATE FUNCTION dbo.fn_ParseElapsedTime(@elapsed_time NVARCHAR(50))
RETURNS INT
AS
BEGIN
    DECLARE @result INT;
    
    IF @elapsed_time IS NULL 
        RETURN NULL;
    
    IF LEN(@elapsed_time) - LEN(REPLACE(@elapsed_time, ':', '')) = 2
    BEGIN
        IF ISNUMERIC(SUBSTRING(@elapsed_time, 1, 2)) = 1 
           AND ISNUMERIC(SUBSTRING(@elapsed_time, 4, 2)) = 1 
           AND ISNUMERIC(LEFT(SUBSTRING(@elapsed_time, 7, 10), CHARINDEX('.', SUBSTRING(@elapsed_time, 7, 10) + '.') - 1)) = 1
        BEGIN
            SET @result = CAST(SUBSTRING(@elapsed_time, 1, 2) AS INT) * 3600 +
                         CAST(SUBSTRING(@elapsed_time, 4, 2) AS INT) * 60 +
                         CAST(LEFT(SUBSTRING(@elapsed_time, 7, 10), CHARINDEX('.', SUBSTRING(@elapsed_time, 7, 10) + '.') - 1) AS INT);
        END
        ELSE
            SET @result = -9999;
    END
    ELSE
    BEGIN
        IF ISNUMERIC(SUBSTRING(@elapsed_time, 1, 2)) = 1 
           AND ISNUMERIC(LEFT(SUBSTRING(@elapsed_time, 4, 10), CHARINDEX('.', SUBSTRING(@elapsed_time, 4, 10) + '.') - 1)) = 1
        BEGIN
            SET @result = CAST(SUBSTRING(@elapsed_time, 1, 2) AS INT) * 60 +
                         CAST(LEFT(SUBSTRING(@elapsed_time, 4, 10), CHARINDEX('.', SUBSTRING(@elapsed_time, 4, 10) + '.') - 1) AS INT);
        END
        ELSE
            SET @result = -9999;
    END
    
    RETURN @result;
END;
GO

DECLARE @year INT = 2026;
DECLARE @week INT = 08;
DECLARE @start_date DATE = DATEADD(WEEK, @week - 1, DATEADD(YEAR, @year - 1900, '1900-01-01'));
DECLARE @end_date DATE = DATEADD(DAY, 7, @start_date);

SELECT rmi.ID,
    rmi.Master_Incident_Number,
    rmi.Response_Date,
    rmi.Agency_Type,
    rmi.Jurisdiction,
    rmi.Problem,
    rmi.Priority_Number,
    rmi.MethodofCallRcvd,
    rmi.CallTaking_Performed_By,
    rmi.ClockStartTime,
    rmi.Time_PhonePickUp,
    rmi.Fixed_Time_PhonePickUp,
    rmi.Time_FirstCallTakingKeystroke,
    rmi.TimeCallViewed,
    rmi.Time_CallEnteredQueue,
    rmi.Fixed_Time_CallEnteredQueue,
    al.First_Queue_Time,
    rmi.Time_CallTakingComplete,
    rmi.Fixed_Time_CallTakingComplete,
    rmi.Time_First_Unit_Assigned,
    al.First_Dispatch_Time,
    al.First_Dispatcher_Init,
    p.Emp_Name,
    e.TimeFirstUnitDispatchAcknowledged,
    rmi.Time_First_Unit_Enroute,
    al.First_Enroute_Time,
    rmi.Time_First_Unit_Arrived,
    al.First_OnScene_Time,
    rmi.TimeFirstCallCleared,
    rmi.Fixed_Time_CallClosed,
    rmi.Time_CallClosed,
    al.First_Closed_Time,
    al.First_Reopen_Time,
    al.Final_Closed_Time,
    rmi.Call_Disposition,
    rmi.Elapsed_CallRcvd2InQueue,
    rmi.Elapsed_CallRcvd2CalTakDone,
    rmi.Elapsed_InQueue_2_FirstAssign,
    rmi.Elapsed_CallRcvd2FirstAssign,
    rmi.Elapsed_Assigned2FirstEnroute,
    rmi.Elapsed_Enroute2FirstAtScene,
    rmi.Elapsed_CallRcvd2CallClosed,
    dbo.fn_ParseElapsedTime(rmi.Elapsed_CallRcvd2InQueue) AS [Elapsed_PS_Queue],
    dbo.fn_ParseElapsedTime(rmi.Elapsed_CallRcvd2CalTakDone) AS [Elapsed_PS_CTD],
    dbo.fn_ParseElapsedTime(rmi.Elapsed_InQueue_2_FirstAssign) AS [Elapsed_Queue_Disp],
    dbo.fn_ParseElapsedTime(rmi.Elapsed_CallRcvd2FirstAssign) AS [Elapsed_Processing],
    dbo.fn_ParseElapsedTime(rmi.Elapsed_Assigned2FirstEnroute) AS [Elapsed_Rollout],
    dbo.fn_ParseElapsedTime(rmi.Elapsed_Enroute2FirstAtScene) AS [Elapsed_Transit],
    dbo.fn_ParseElapsedTime(rmi.Elapsed_CallRcvd2CallClosed) AS [Elapsed_Call_Time]
FROM Response_Master_Incident rmi 
    JOIN Response_Master_Incident_Ext e ON rmi.ID = e.Master_Incident_ID
    LEFT JOIN (
        SELECT 
            Master_Incident_ID,
            MIN(CASE WHEN Activity = 'Incident in Waiting Queue' THEN Date_Time END) AS First_Queue_Time,
            MIN(CASE WHEN Activity = 'Dispatched' THEN Date_Time END) AS First_Dispatch_Time,
            MIN(CASE WHEN Activity = 'En Route' THEN Date_Time END) AS First_Enroute_Time,
            MIN(CASE WHEN Activity = 'On Scene' THEN Date_Time END) AS First_OnScene_Time,
            MIN(CASE WHEN Activity = 'Response Closed' THEN Date_Time END) AS First_Closed_Time,
            MAX(CASE WHEN Activity = 'Response Closed' THEN Date_Time END) AS Final_Closed_Time,
            MIN(CASE WHEN Activity = 'Incident Reopen' THEN Date_Time END) AS First_Reopen_Time,
            MIN(CASE WHEN Activity = 'Dispatched' THEN Dispatcher_Init END) AS First_Dispatcher_Init
        FROM Activity_Log
        GROUP BY Master_Incident_ID
    ) al ON rmi.ID = al.Master_Incident_ID
    LEFT JOIN Personnel p ON al.First_Dispatcher_Init = p.Emp_ID
WHERE DATEPART(WEEK, Response_Date) = @week
AND DATEPART(YEAR, Response_Date) = @year
AND ((al.First_Dispatch_Time IS NOT NULL) OR (al.First_Dispatch_Time != ''));