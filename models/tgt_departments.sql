{{
    config(
        materialized="incremental",
        incremental_strategy="merge",
        unique_key="department_id",
        on_schema_change="sync_all_columns",
    )
}}

select

    src.department_id,
    src.department_name,
    src.manager_id,
    src.location_id,
    src.updated_date
from {{ source("src", "src_departments") }} src

{% if is_incremental() %}
    where src.updated_date > (select max(updated_date) from {{ this }})
{% endif %}
