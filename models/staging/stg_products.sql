WITH source AS (
    SELECT * FROM {{ source('bronze', 'products') }}
)

SELECT
    product_id,
    name as product_name,
    category,
    retail_price,
    supplier_price,
    supplier_id,
    retail_price - supplier_price as margin_amount,
    ((retail_price - supplier_price) / retail_price) * 100 as margin_percent,
    updated_at
FROM source
WHERE product_id IS NOT NULL