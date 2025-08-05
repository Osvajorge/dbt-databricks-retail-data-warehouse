select
    order_id,
    count(*) as count_of_ids

from {{ ref('fct_orders') }}

group by order_id
having count(*) > 1