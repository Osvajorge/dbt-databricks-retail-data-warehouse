WITH source AS (
    SELECT * FROM {{ source('bronze', 'order_items') }}
)

SELECT
    order_item_id,
    order_id,      
    product_id,    
    quantity,
    unit_price,
    quantity * unit_price AS line_total,  
    updated_at
FROM source  
WHERE order_item_id IS NOT NULL