WITH customer_metrics AS (
    SELECT 
        c.customer_id,
        c.customer_name,
        c.email,
        c.city,
        c.state,
        COUNT(DISTINCT o.order_id) as total_orders,
        SUM(o.revenue) as lifetime_revenue,
        AVG(o.revenue) as avg_order_value,
        MAX(o.order_date) as last_order_date,
        DATEDIFF(CURRENT_DATE(), MAX(o.order_date)) as days_since_last_order
    FROM {{ ref('stg_customers') }} c
    LEFT JOIN {{ ref('fct_orders') }} o 
        ON c.customer_id = o.customer_id
        AND o.status_desc = 'Completed'
    GROUP BY 1,2,3,4,5
),

segments AS (
    SELECT * FROM {{ ref('customer_segments') }}
)

SELECT 
    cm.*,
    s.segment_name,
    CASE 
        WHEN cm.days_since_last_order <= 30 THEN 'Active'
        WHEN cm.days_since_last_order <= 90 THEN 'At Risk'
        WHEN cm.days_since_last_order <= 180 THEN 'Dormant'
        ELSE 'Lost'
    END as activity_status,
    CONCAT(s.segment_name, ' - ',
        CASE 
            WHEN cm.days_since_last_order <= 30 THEN 'Active'
            WHEN cm.days_since_last_order <= 90 THEN 'At Risk'
            ELSE 'Inactive'
        END
    ) as customer_classification
FROM customer_metrics cm
LEFT JOIN segments s
    ON cm.total_orders >= s.min_orders 
    AND cm.total_orders <= s.max_orders
    AND cm.lifetime_revenue >= s.min_revenue 
    AND cm.lifetime_revenue <= s.max_revenue