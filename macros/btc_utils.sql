{% macro convert_to_usd(col) %}

{{col}} * (
    select close_price_usd
    from {{ ref('btc_usd_max') }}
    where to_date(replace(event_date, ' UTC', '')) = '2026-10-14'
)

{% endmacro %}