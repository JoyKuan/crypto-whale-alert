{{
    config(materialized='incremental', incremental_strategy='append')
}}

with flattened_outputs as (
    select
        t.hash_key,
        t.block_hash,
        t.block_number,
        t.block_timestamp,
        t.is_coinbase,
        f.value:address::string as output_address,
        f.value:value::float as output_value
    from {{ ref('stg_btc') }} t, lateral flatten(input => t.outputs) f
    where f.value:address is not null

    {% if is_incremental() %}
        and t.block_timestamp >= (select max(block_timestamp) from {{ this }})
    {% endif %}
)

select 
    hash_key,
    block_hash,
    block_number,
    block_timestamp,
    is_coinbase,
    output_address,
    output_value
from flattened_outputs
