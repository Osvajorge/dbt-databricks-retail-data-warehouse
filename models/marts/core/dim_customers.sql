-- Dimension table for customers with enriched attributes
WITH customer_base AS (
    SELECT * FROM {{ ref('stg_customers') }}
),

customer_metrics AS (
    SELECT 
        customer_id,
        COUNT(DISTINCT order_id) as total_orders,
        SUM(revenue) as lifetime_revenue,
        AVG(revenue) as avg_order_value,
        MIN(order_date) as first_order_date,
        MAX(order_date) as last_order_date,
        DATEDIFF(CURRENT_DATE(), MAX(order_date)) as days_since_last_order
    FROM {{ ref('fct_orders') }}
    WHERE status_desc = 'Completed'
    GROUP BY customer_id
),

customer_segments AS (
    SELECT * FROM {{ ref('customer_segments') }}
)

SELECT 
    cb.customer_id,
    cb.first_name,
    cb.last_name,
    cb.customer_name,
    cb.email,
    cb.phone,
    cb.address,
    cb.city,
    cb.state,
    cb.zip_code,
    cb.updated_at,
    
    -- Enriched metrics
    COALESCE(cm.total_orders, 0) as total_orders,
    COALESCE(cm.lifetime_revenue, 0) as lifetime_revenue,
    COALESCE(cm.avg_order_value, 0) as avg_order_value,
    cm.first_order_date,
    cm.last_order_date,
    cm.days_since_last_order,
    
    -- Customer segmentation
    CASE 
        WHEN cm.days_since_last_order IS NULL THEN 'Prospect'
        WHEN cm.days_since_last_order <= 30 THEN 'Active'
        WHEN cm.days_since_last_order <= 90 THEN 'At Risk'
        WHEN cm.days_since_last_order <= 180 THEN 'Dormant'
        ELSE 'Lost'
    END as activity_status,
    
    -- Value segmentation based on lifetime revenue
    CASE 
        WHEN COALESCE(cm.lifetime_revenue, 0) = 0 THEN 'Prospect'
        WHEN cm.lifetime_revenue < 100 THEN 'New'
        WHEN cm.lifetime_revenue < 1000 THEN 'Regular'
        WHEN cm.lifetime_revenue < 10000 THEN 'VIP'
        ELSE 'Platinum'
    END as value_segment,
    
    -- Geographic classification
    CASE 
        WHEN cb.state IN ('CA', 'WA', 'OR', 'NV', 'AZ') THEN 'West'
        WHEN cb.state IN ('TX', 'OK', 'AR', 'LA', 'NM') THEN 'Southwest'
        WHEN cb.state IN ('IL', 'IN', 'MI', 'OH', 'WI') THEN 'Midwest'
        WHEN cb.state IN ('NY', 'NJ', 'PA', 'CT', 'MA', 'ME', 'NH', 'VT', 'RI') THEN 'Northeast'
        WHEN cb.state IN ('FL', 'GA', 'SC', 'NC', 'VA', 'TN', 'KY', 'WV', 'MD', 'DE', 'DC') THEN 'Southeast'
        ELSE 'Other'
    END as region
FROM customer_base cb
LEFT JOIN customer_metrics cm 
    ON cb.customer_id = cm.customer_id