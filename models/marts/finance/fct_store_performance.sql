WITH monthly_store_revenue AS (
    SELECT 
        store_id,
        DATE_TRUNC('month', order_date) as month,
        COUNT(DISTINCT order_id) as order_count,
        COUNT(DISTINCT customer_id) as unique_customers,
        SUM(revenue) as actual_revenue
    FROM {{ ref('fct_orders') }}
    WHERE status_desc = 'Completed'
    GROUP BY 1, 2
),

store_info AS (
    SELECT * FROM {{ ref('stg_stores') }}
),

targets AS (
    SELECT * FROM {{ ref('store_targets') }}  -- ← SEED
)

SELECT 
    si.store_name,
    si.store_type,
    si.city,
    si.state,
    msr.month,
    msr.order_count,
    msr.unique_customers,
    msr.actual_revenue,
    t.monthly_target,                         -- ← SEED
    msr.actual_revenue - t.monthly_target as variance,
    (msr.actual_revenue / t.monthly_target) * 100 as achievement_percent,
    CASE 
        WHEN (msr.actual_revenue / t.monthly_target) >= 1.1 THEN 'Exceeding'
        WHEN (msr.actual_revenue / t.monthly_target) >= 0.9 THEN 'On Track'
        ELSE 'Below Target'
    END as performance_status
FROM monthly_store_revenue msr
JOIN store_info si ON msr.store_id = si.store_id
JOIN targets t ON msr.store_id = t.store_id