-- Dimension table for stores with targets and performance classification
WITH store_base AS (
    SELECT * FROM {{ ref('stg_stores') }}
),

store_targets AS (
    SELECT * FROM {{ ref('store_targets') }}
),

store_metrics AS (
    SELECT 
        s.store_id,
        COUNT(DISTINCT o.order_id) as total_orders,
        COUNT(DISTINCT o.customer_id) as unique_customers,
        SUM(o.revenue) as total_revenue,
        AVG(o.revenue) as avg_order_value,
        MAX(o.order_date) as last_order_date,
        MIN(o.order_date) as first_order_date
    FROM {{ ref('stg_stores') }} s
    LEFT JOIN {{ ref('fct_orders') }} o ON s.store_id = o.store_id
    WHERE o.status_desc = 'Completed' OR o.status_desc IS NULL
    GROUP BY s.store_id
)

SELECT 
    sb.store_id,
    sb.store_name,
    sb.address,
    sb.city,
    sb.state,
    sb.zip_code,
    sb.email,
    sb.phone,
    sb.store_type,
    sb.updated_at,
    
    -- Targets information
    COALESCE(st.monthly_target, 0) as monthly_target,
    COALESCE(st.yearly_target, 0) as yearly_target,
    
    -- Performance metrics
    COALESCE(sm.total_orders, 0) as total_orders,
    COALESCE(sm.unique_customers, 0) as unique_customers,
    COALESCE(sm.total_revenue, 0) as total_revenue,
    COALESCE(sm.avg_order_value, 0) as avg_order_value,
    sm.last_order_date,
    sm.first_order_date,
    
    -- Geographic classification
    CASE 
        WHEN sb.state IN ('CA', 'WA', 'OR', 'NV', 'AZ') THEN 'West'
        WHEN sb.state IN ('TX', 'OK', 'AR', 'LA', 'NM') THEN 'Southwest'
        WHEN sb.state IN ('IL', 'IN', 'MI', 'OH', 'WI') THEN 'Midwest'
        WHEN sb.state IN ('NY', 'NJ', 'PA', 'CT', 'MA', 'ME', 'NH', 'VT', 'RI') THEN 'Northeast'
        WHEN sb.state IN ('FL', 'GA', 'SC', 'NC', 'VA', 'TN', 'KY', 'WV', 'MD', 'DE', 'DC') THEN 'Southeast'
        ELSE 'Other'
    END as region,
    
    -- Store size classification based on revenue
    CASE 
        WHEN COALESCE(sm.total_revenue, 0) = 0 THEN 'Inactive'
        WHEN sm.total_revenue < 50000 THEN 'Small'
        WHEN sm.total_revenue < 200000 THEN 'Medium'
        WHEN sm.total_revenue < 500000 THEN 'Large'
        ELSE 'Flagship'
    END as store_size_category,
    
    -- Performance vs target (using yearly for simplicity)
    CASE 
        WHEN st.yearly_target = 0 OR st.yearly_target IS NULL THEN 'No Target'
        WHEN COALESCE(sm.total_revenue, 0) = 0 THEN 'No Sales'
        WHEN (sm.total_revenue / st.yearly_target) >= 1.1 THEN 'Exceeding Target'
        WHEN (sm.total_revenue / st.yearly_target) >= 0.9 THEN 'Meeting Target'
        WHEN (sm.total_revenue / st.yearly_target) >= 0.7 THEN 'Below Target'
        ELSE 'Significantly Below'
    END as target_performance,
    
    -- Customer loyalty indicator
    CASE 
        WHEN COALESCE(sm.total_orders, 0) = 0 THEN NULL
        WHEN (sm.total_orders::FLOAT / NULLIF(sm.unique_customers, 0)) >= 3.0 THEN 'High Loyalty'
        WHEN (sm.total_orders::FLOAT / NULLIF(sm.unique_customers, 0)) >= 2.0 THEN 'Medium Loyalty'
        ELSE 'Low Loyalty'
    END as customer_loyalty_tier,
    
    -- Operating status
    CASE 
        WHEN sb.store_type = 'Warehouse' THEN 'Distribution Center'
        WHEN sm.last_order_date IS NULL THEN 'Inactive'
        WHEN sm.last_order_date >= DATEADD(DAY, -30, CURRENT_DATE()) THEN 'Active'
        WHEN sm.last_order_date >= DATEADD(DAY, -90, CURRENT_DATE()) THEN 'Low Activity'
        ELSE 'Dormant'
    END as operating_status

FROM store_base sb
LEFT JOIN store_targets st ON sb.store_id = st.store_id
LEFT JOIN store_metrics sm ON sb.store_id = sm.store_id