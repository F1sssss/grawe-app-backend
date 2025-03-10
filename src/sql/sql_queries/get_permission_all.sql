select distinct
    permission_id as id,
    route,
    method,
    visibility,
    name,
    description
from vw_all_permissions
order by permission_id