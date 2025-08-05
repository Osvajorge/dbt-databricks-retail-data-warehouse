select
    customer_id

from {{ ref('fct_orders') }}

where customer_id is null