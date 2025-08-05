WITH source AS (
    SELECT * FROM {{ source('bronze', 'employees') }}
)

SELECT
    employee_id,
    first_name,
    last_name,
    CONCAT(first_name, ' ', last_name) as employee_name,
    email,
    job_title,
    hire_date,
    manager_id,
    address,
    city,
    state,
    zip_code,
    DATEDIFF(CURRENT_DATE(), hire_date) as days_employed,
    updated_at
FROM source
WHERE employee_id IS NOT NULL