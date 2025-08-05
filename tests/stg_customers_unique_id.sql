select
    customer_id,
    count(*) as count_of_ids

from {{ ref('stg_customers') }}

group by customer_id
having count(*) > 1