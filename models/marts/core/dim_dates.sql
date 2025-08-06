-- Dimension table for dates with comprehensive calendar attributes
WITH date_base AS (
    SELECT * FROM {{ ref('stg_dates') }}
)

SELECT 
    date_id,
    day,
    month,
    year,
    quarter,
    day_of_week,
    week_of_year,
    is_weekend,
    updated_at,
    
    -- Enhanced date attributes
    CASE 
        WHEN month IN ('January', 'February', 'March') THEN 'Q1'
        WHEN month IN ('April', 'May', 'June') THEN 'Q2'
        WHEN month IN ('July', 'August', 'September') THEN 'Q3'
        ELSE 'Q4'
    END as quarter_name,
    
    -- Month number
    CASE month
        WHEN 'January' THEN 1
        WHEN 'February' THEN 2
        WHEN 'March' THEN 3
        WHEN 'April' THEN 4
        WHEN 'May' THEN 5
        WHEN 'June' THEN 6
        WHEN 'July' THEN 7
        WHEN 'August' THEN 8
        WHEN 'September' THEN 9
        WHEN 'October' THEN 10
        WHEN 'November' THEN 11
        WHEN 'December' THEN 12
    END as month_number,
    
    -- Month abbreviation
    CASE month
        WHEN 'January' THEN 'Jan'
        WHEN 'February' THEN 'Feb'
        WHEN 'March' THEN 'Mar'
        WHEN 'April' THEN 'Apr'
        WHEN 'May' THEN 'May'
        WHEN 'June' THEN 'Jun'
        WHEN 'July' THEN 'Jul'
        WHEN 'August' THEN 'Aug'
        WHEN 'September' THEN 'Sep'
        WHEN 'October' THEN 'Oct'
        WHEN 'November' THEN 'Nov'
        WHEN 'December' THEN 'Dec'
    END as month_abbr,
    
    -- Day of week number (Monday = 1)
    CASE day_of_week
        WHEN 'Monday' THEN 1
        WHEN 'Tuesday' THEN 2
        WHEN 'Wednesday' THEN 3
        WHEN 'Thursday' THEN 4
        WHEN 'Friday' THEN 5
        WHEN 'Saturday' THEN 6
        WHEN 'Sunday' THEN 7
    END as day_of_week_number,
    
    -- Day abbreviation
    CASE day_of_week
        WHEN 'Monday' THEN 'Mon'
        WHEN 'Tuesday' THEN 'Tue'
        WHEN 'Wednesday' THEN 'Wed'
        WHEN 'Thursday' THEN 'Thu'
        WHEN 'Friday' THEN 'Fri'
        WHEN 'Saturday' THEN 'Sat'
        WHEN 'Sunday' THEN 'Sun'
    END as day_abbr,
    
    -- Business day indicator
    CASE 
        WHEN day_of_week IN ('Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday') THEN true
        ELSE false
    END as is_weekday,
    
    -- Season classification
    CASE 
        WHEN month IN ('December', 'January', 'February') THEN 'Winter'
        WHEN month IN ('March', 'April', 'May') THEN 'Spring'
        WHEN month IN ('June', 'July', 'August') THEN 'Summer'
        ELSE 'Fall'
    END as season,
    
    -- Holiday indicators (basic US holidays) - using DAY() function to get day number
    CASE 
        WHEN month = 'January' AND DAY(date_id) = 1 THEN 'New Year''s Day'
        WHEN month = 'February' AND DAY(date_id) = 14 THEN 'Valentine''s Day'
        WHEN month = 'July' AND DAY(date_id) = 4 THEN 'Independence Day'
        WHEN month = 'October' AND DAY(date_id) = 31 THEN 'Halloween'
        WHEN month = 'December' AND DAY(date_id) = 25 THEN 'Christmas Day'
        WHEN month = 'December' AND DAY(date_id) = 31 THEN 'New Year''s Eve'
        ELSE NULL
    END as holiday_name,
    
    -- Shopping season classification
    CASE 
        WHEN month = 'November' OR (month = 'December' AND DAY(date_id) <= 25) THEN 'Holiday Season'
        WHEN month IN ('January', 'February') THEN 'Post-Holiday'
        WHEN month IN ('March', 'April', 'May') THEN 'Spring Season'
        WHEN month IN ('June', 'July', 'August') THEN 'Summer Season'
        WHEN month IN ('September', 'October') THEN 'Back-to-School'
        ELSE 'Regular Season'
    END as shopping_season,
    
    -- Fiscal year (assuming Jan-Dec)
    year as fiscal_year,
    
    -- Date formatting using DATE functions
    CONCAT(year, '-', 
           LPAD(CAST(CASE month
               WHEN 'January' THEN 1 WHEN 'February' THEN 2 WHEN 'March' THEN 3
               WHEN 'April' THEN 4 WHEN 'May' THEN 5 WHEN 'June' THEN 6
               WHEN 'July' THEN 7 WHEN 'August' THEN 8 WHEN 'September' THEN 9
               WHEN 'October' THEN 10 WHEN 'November' THEN 11 WHEN 'December' THEN 12
           END AS STRING), 2, '0'), '-',
           LPAD(CAST(DAY(date_id) AS STRING), 2, '0')) as date_formatted,
    
    -- Year-Month for aggregations
    CONCAT(year, '-', LPAD(CAST(CASE month
        WHEN 'January' THEN 1 WHEN 'February' THEN 2 WHEN 'March' THEN 3
        WHEN 'April' THEN 4 WHEN 'May' THEN 5 WHEN 'June' THEN 6
        WHEN 'July' THEN 7 WHEN 'August' THEN 8 WHEN 'September' THEN 9
        WHEN 'October' THEN 10 WHEN 'November' THEN 11 WHEN 'December' THEN 12
    END AS STRING), 2, '0')) as year_month,
    
    -- Relative date indicators (assuming current date context)
    CASE 
        WHEN date_id = CURRENT_DATE() THEN 'Today'
        WHEN date_id = DATEADD(DAY, -1, CURRENT_DATE()) THEN 'Yesterday'
        WHEN date_id = DATEADD(DAY, 1, CURRENT_DATE()) THEN 'Tomorrow'
        ELSE NULL
    END as relative_date

FROM date_base