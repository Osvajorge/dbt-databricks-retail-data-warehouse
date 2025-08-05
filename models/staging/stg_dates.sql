WITH source AS (
    SELECT * FROM {{ source('bronze', 'dates') }}
)

SELECT
    date_id,
    day,
    month,
    year,
    quarter,
    day_of_week,
    week_of_year,
    CASE 
        WHEN day_of_week IN ('Saturday', 'Sunday') THEN true 
        ELSE false 
    END as is_weekend,
    updated_at
FROM source
WHERE date_id IS NOT NULL