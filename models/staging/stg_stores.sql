WITH source AS (
    SELECT * FROM {{ source('bronze', 'stores') }}
)

SELECT
    store_id,
    store_name,
    address,
    city,
    state,
    zip_code,
    email,
    phone,
    CASE 
        WHEN store_name LIKE '%Warehouse%' THEN 'Warehouse'
        WHEN store_name LIKE '%Online%' THEN 'Online'
        ELSE 'Retail'
    END as store_type,
    updated_at
FROM source
WHERE store_id IS NOT NULL