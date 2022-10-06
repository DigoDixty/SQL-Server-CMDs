CREATE FUNCTION [dbo].[fn_10days_u]
(
    @date  date
) 
RETURNS DATE
AS
BEGIN
DECLARE @X int = 0
DECLARE @Day date = @date
--DECLARE @Day date = '2022-07-01'
IF ( DATEPART(WEEKDAY, @DAY) = 2 AND dbo.fn_IsHoliday(@DAY) = 1 ) BEGIN SET @X = 1 END
IF DATEPART(WEEKDAY, @DAY) IN (1, 7) BEGIN SET @X = 1 END
WHILE ( @X < 10 )
BEGIN
    IF dbo.fn_IsHoliday(@DAY) = 0 AND DATEPART(WEEKDAY, @DAY) NOT IN (1,7) 
        BEGIN
            SET @Day = (SELECT dateadd(DAY,-1,@Day))
            SET @X = @X + 1
        END
    ELSE
        BEGIN
            SET @Day = (SELECT dateadd(DAY,-1,@Day))
        END
END
IF ( DATEPART(WEEKDAY, @DAY) = 2 AND dbo.fn_IsHoliday(@DAY) = 1 ) BEGIN SET @Day = (SELECT dateadd(DAY,-3,@Day)) END
-- SELECT @DAY
RETURN @DAY
END
;