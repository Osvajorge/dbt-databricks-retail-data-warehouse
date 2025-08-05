WITH employees AS (
    SELECT
        employee_id,
        employee_name,
        job_title,
        hire_date,
        manager_id
    FROM {{ ref('stg_employees') }}
),

employee_orders AS (
    SELECT 
        e.employee_id,
        e.employee_name,
        e.job_title,
        e.manager_id,
        DATEDIFF(CURRENT_DATE(), e.hire_date) / 365 AS years_employed,
        COUNT(o.order_id) AS total_orders,
        SUM(o.revenue) AS total_revenue,
        SUM(o.item_count) AS total_items  
    FROM employees e
    JOIN {{ ref('fct_orders') }} o ON e.employee_id = o.employee_id  
    WHERE o.status_desc = 'Completed'
    GROUP BY 1, 2, 3, 4, 5
)

SELECT 
    eo.employee_name,
    eo.job_title,
    eo.total_orders,
    eo.total_revenue,
    eo.total_items,
    ROUND(eo.years_employed, 1) as years_employed,
    m.employee_name as manager_name
FROM employee_orders eo
LEFT JOIN employees m ON eo.manager_id = m.employee_id
ORDER BY eo.total_orders DESC, eo.total_revenue DESC;

