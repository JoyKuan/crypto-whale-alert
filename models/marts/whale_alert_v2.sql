with whale as (
    select
        output_address,
        sum(output_value) as total_sent,
        count(*) as transaction_count
    from {{ ref('stg_btc_transactions') }}
    where  output_value > 1000
    group by output_address
    order by total_sent desc
)

select
    '{{ invocation_id }}' as invocation_id,
    output_address,
    total_sent,
    transaction_count
from whale
order by total_sent desc