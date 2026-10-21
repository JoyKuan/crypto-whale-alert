{{
    config(materialized='incremental', incremental_strategy='merge', unique_key='hash_key')
}}

select
    '{{ invocation_id }}' as invocation_id, 
    * 
from {{ source('btc', 'btc_txn') }}

{% if is_incremental() %}
where block_timestamp >= (select max(block_timestamp) from {{ this }})
{% endif %}