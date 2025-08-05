WITH monthly_sales AS (
    SELECT 
        DATE_TRUNC('month', order_date) as sales_month,
        store_id,
        COUNT(DISTINCT order_id) as total_orders,
        COUNT(DISTINCT customer_id) as unique_customers,
        SUM(revenue) as total_revenue,
        AVG(revenue) as avg_order_value,
        SUM(item_count) as total_items_sold
    FROM {{ ref('fct_orders') }}
    WHERE status_desc = 'Completed'
    GROUP BY 1, 2
)

SELECT 
    ms.sales_month,
    s.store_name,
    s.store_type,
    s.city,
    ms.total_orders,
    ms.unique_customers,
    ms.total_revenue,
    ROUND(ms.avg_order_value, 2) as avg_order_value,
    ms.total_items_sold,
    ROUND(ms.total_revenue / ms.total_orders, 2) as revenue_per_order
FROM monthly_sales ms
JOIN {{ ref('stg_stores') }} s ON ms.store_id = s.store_id
ORDER BY ms.sales_month DESC, ms.total_revenue DESC;