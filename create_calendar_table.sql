DECLARE @StartDate  date = '20220101';

DECLARE @CutoffDate date = DATEADD(DAY, -1, DATEADD(YEAR, 30, @StartDate));

;WITH seq(n) AS 
(
  SELECT 0 UNION ALL SELECT n + 1 FROM seq
  WHERE n < DATEDIFF(DAY, @StartDate, @CutoffDate)
),
d(d) AS 
(
  SELECT DATEADD(DAY, n, @StartDate) FROM seq
),
src AS
(
  SELECT
    TheDate         = CONVERT(date,       d),
    TheDay          = DATEPART(DAY,       d),
    TheDayName      = DATENAME(WEEKDAY,   d),
    TheWeek         = DATEPART(WEEK,      d),
    TheISOWeek      = DATEPART(ISO_WEEK,  d),
    TheDayOfWeek    = DATEPART(WEEKDAY,   d),
    TheMonth        = DATEPART(MONTH,     d),
    TheMonthName    = DATENAME(MONTH,     d),
    TheQuarter      = DATEPART(Quarter,   d),
    TheYear         = DATEPART(YEAR,      d),
    TheFirstOfMonth = DATEFROMPARTS(YEAR(d), MONTH(d), 1),
    TheLastOfYear   = DATEFROMPARTS(YEAR(d), 12, 31),
    TheDayOfYear    = DATEPART(DAYOFYEAR, d)
  FROM d
)
SELECT * 
INTO CALENDAR
FROM src
ORDER BY TheDate
OPTION (MAXRECURSION 0)
;

SELECT MIN(TheDate), MAX(TheDate), count(1) FROM CALENDAR;
-- 11 rows

ALTER TABLE CALENDAR
ADD last_10u_day date;

ALTER TABLE CALENDAR
ADD is_holiday BIT;

ALTER TABLE CALENDAR
ADD desc_holiday varchar(100);

UPDATE CALENDAR 
SET is_holiday = dbo.fn_IsHoliday(TheDate)
;

UPDATE CALENDAR 
SET desc_holiday = dbo.fn_IsHoliday_desc(TheDate)
;

UPDATE CALENDAR 
SET last_10u_day = dbo.fn_10days_u(TheDate)
;



