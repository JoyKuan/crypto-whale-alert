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
    output_address,
    total_sent,
    transaction_count,
    {{ convert_to_usd('total_sent') }} as total_sent_usd
from whale
order by total_sent desc