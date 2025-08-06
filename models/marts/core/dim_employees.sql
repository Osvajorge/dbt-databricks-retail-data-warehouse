-- Dimension table for employees with role information and performance metrics
WITH employee_base AS (
    SELECT * FROM {{ ref('stg_employees') }}
),

employee_roles AS (
    SELECT * FROM {{ ref('employee_roles') }}
),

manager_info AS (
    SELECT 
        employee_id,
        employee_name as manager_name
    FROM {{ ref('stg_employees') }}
),

employee_metrics AS (
    SELECT 
        e.employee_id,
        COUNT(DISTINCT o.order_id) as total_orders_processed,
        SUM(o.revenue) as total_revenue_generated,
        AVG(o.revenue) as avg_order_value,
        MAX(o.order_date) as last_order_processed
    FROM {{ ref('stg_employees') }} e
    LEFT JOIN {{ ref('fct_orders') }} o ON e.employee_id = o.employee_id
    WHERE o.status_desc = 'Completed' OR o.status_desc IS NULL
    GROUP BY e.employee_id
)

SELECT 
    eb.employee_id,
    eb.first_name,
    eb.last_name,
    eb.employee_name,
    eb.email,
    eb.job_title,
    eb.hire_date,
    eb.manager_id,
    eb.address,
    eb.city,
    eb.state,
    eb.zip_code,
    eb.days_employed,
    eb.updated_at,
    
    -- Manager information
    mi.manager_name,
    
    -- Role information from seed
    COALESCE(er.role_level, 1) as role_level,
    COALESCE(er.can_approve_orders, false) as can_approve_orders,
    COALESCE(er.max_discount_percent, 0) as max_discount_percent,
    
    -- Performance metrics
    COALESCE(em.total_orders_processed, 0) as total_orders_processed,
    COALESCE(em.total_revenue_generated, 0) as total_revenue_generated,
    COALESCE(em.avg_order_value, 0) as avg_order_value,
    em.last_order_processed,
    
    -- Calculated fields
    ROUND(eb.days_employed / 365.25, 1) as years_employed,
    
    -- Employment tenure classification
    CASE 
        WHEN eb.days_employed < 90 THEN 'New Hire'
        WHEN eb.days_employed < 365 THEN 'Junior'
        WHEN eb.days_employed < 1095 THEN 'Experienced'  -- 3 years
        ELSE 'Veteran'
    END as tenure_category,
    
    -- Performance classification
    CASE 
        WHEN em.total_orders_processed IS NULL OR em.total_orders_processed = 0 THEN 'No Sales Activity'
        WHEN em.total_orders_processed >= 50 THEN 'High Performer'
        WHEN em.total_orders_processed >= 20 THEN 'Standard Performer'
        ELSE 'Low Activity'
    END as performance_tier,
    
    -- Department classification
    CASE 
        WHEN eb.job_title LIKE '%Manager%' THEN 'Management'
        WHEN eb.job_title IN ('Sales Associate', 'Customer Service') THEN 'Sales'
        WHEN eb.job_title LIKE '%Warehouse%' OR eb.job_title LIKE '%Inventory%' THEN 'Operations'
        WHEN eb.job_title LIKE '%HR%' THEN 'Human Resources'
        WHEN eb.job_title LIKE '%IT%' THEN 'Information Technology'
        WHEN eb.job_title LIKE '%Finance%' THEN 'Finance'
        WHEN eb.job_title LIKE '%Marketing%' THEN 'Marketing'
        ELSE 'Other'
    END as department

FROM employee_base eb
LEFT JOIN manager_info mi ON eb.manager_id = mi.employee_id
LEFT JOIN employee_roles er ON eb.job_title = er.job_title
LEFT JOIN employee_metrics em ON eb.employee_id = em.employee_id