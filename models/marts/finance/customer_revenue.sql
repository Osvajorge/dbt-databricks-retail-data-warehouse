-- models/marts/finance/fct_customer_revenue.sql
WITH orders AS (
    SELECT * FROM {{ ref('fct_orders') }} 
),

customers AS (
    SELECT * FROM {{ ref('stg_customers') }}
)

SELECT
    c.customer_id,
    c.customer_name,
    c.email,
    c.city,
    c.state,
    COUNT(DISTINCT o.order_id) AS order_count,
    SUM(o.revenue) AS total_revenue,
    AVG(o.revenue) AS avg_order_value,
    MAX(o.order_date) AS last_order_date,
    MIN(o.order_date) AS first_order_date
FROM customers c
LEFT JOIN orders o 
    ON c.customer_id = o.customer_id
GROUP BY
    c.customer_id,
    c.customer_name,
    c.email,
    c.city,
    c.state