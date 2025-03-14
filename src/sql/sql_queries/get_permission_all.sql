select distinct
    permission_id,
    route,
    method,
    visibility,
    name,
    description
from vw_all_permissions
order by permission_id