WITH sales_data AS (
    SELECT 
        DATE_TRUNC('month', o.order_date) as sales_month,
        s.store_name,
        s.store_type,
        oi.quantity,
        p.retail_price,
        p.supplier_price
    FROM {{ ref('fct_orders') }} o
    JOIN {{ ref('stg_order_items') }} oi ON o.order_id = oi.order_id
    JOIN {{ ref('stg_products') }} p ON oi.product_id = p.product_id
    JOIN {{ ref('stg_stores') }} s ON o.store_id = s.store_id
    WHERE o.status_desc = 'Completed'
)

SELECT 
    sales_month,
    store_name,
    store_type,
    {{ calculate_profit_metrics('sales_month', 'quantity', 'retail_price', 'supplier_price') }}
FROM sales_data
GROUP BY sales_month, store_name, store_type
ORDER BY sales_month DESC, total_profit DESC