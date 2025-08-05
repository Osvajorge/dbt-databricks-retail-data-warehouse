WITH products AS (
    SELECT 
        product_id,
        product_name,
        margin_amount
    FROM {{ref("stg_products")}}
),

aggregated_data AS (
    SELECT 
        p.product_id,
        p.product_name,
        SUM(oi.quantity) AS total_quantity,
        SUM(oi.line_total) AS total_revenue,
        SUM(p.margin_amount * oi.quantity) AS total_margin,
        ROUND((total_margin / total_revenue) * 100, 2) as margin_percent 
    FROM products p 
    JOIN {{ref("stg_order_items")}} oi 
        ON p.product_id = oi.product_id
    GROUP BY p.product_id, p.product_name
)

SELECT
    ROW_NUMBER() OVER (ORDER BY total_quantity DESC) AS position,
    product_id,
    product_name,
    total_quantity,
    total_revenue,
    total_margin
FROM aggregated_data
ORDER BY total_quantity DESC
LIMIT 10;