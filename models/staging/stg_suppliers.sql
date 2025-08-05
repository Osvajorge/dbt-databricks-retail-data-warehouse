WITH source AS (
    SELECT * FROM {{ source('bronze', 'suppliers') }}
)

SELECT
    supplier_id,
    supplier_name,
    contact_person,
    email,
    phone,
    address,
    city,
    state,
    zip_code,
    updated_at
FROM source
WHERE supplier_id IS NOT NULL