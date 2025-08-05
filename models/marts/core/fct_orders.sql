WITH orders AS (
    SELECT * FROM {{ ref('stg_orders') }}
),

order_items AS (
    SELECT * FROM {{ ref('stg_order_items') }}
),

order_summary AS (
    SELECT
        order_id,
        COUNT(DISTINCT order_item_id) AS item_count,
        SUM(line_total) AS order_revenue,
        SUM(quantity) AS total_quantity
    FROM order_items
    GROUP BY order_id
)

SELECT
    o.order_id,
    o.order_date,
    o.customer_id,
    o.employee_id,
    o.store_id,
    o.status_cd,
    o.status_desc,
    o.updated_at,
    COALESCE(os.item_count, 0) AS item_count,
    COALESCE(os.order_revenue, 0) AS revenue,
    COALESCE(os.total_quantity, 0) AS total_quantity
FROM orders o
LEFT JOIN order_summary os 
    ON o.order_id = os.order_id