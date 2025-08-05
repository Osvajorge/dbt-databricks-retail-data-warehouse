WITH source AS (
    SELECT * FROM {{ source('bronze', 'orders') }}
)

SELECT
    order_id,
    order_date,
    customer_id,
    employee_id,
    store_id,
    status AS status_cd,
    CASE
        WHEN status = 'completed' THEN 'Completed'
        WHEN status = 'processing' THEN 'In Progress'
        WHEN status = 'cancelled' THEN 'Cancelled'
        ELSE 'Unknown'
    END AS status_desc,
    updated_at
FROM source
WHERE order_id IS NOT NULL