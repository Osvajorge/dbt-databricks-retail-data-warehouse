WITH source AS (
    SELECT * FROM {{ source('bronze', 'customers') }}
)

SELECT
    customer_id,      
    first_name,
    last_name,
    email,
    phone,
    address,
    city,
    state,          
    zip_code,
    updated_at,      
    CONCAT(first_name, ' ', last_name) AS customer_name 
FROM source
WHERE customer_id IS NOT NULL