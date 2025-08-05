select

    status_cd
    
from {{ ref('stg_orders') }}
where status_cd not in ('processing', 'cancelled', 'completed') 