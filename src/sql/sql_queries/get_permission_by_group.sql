select
    permission_id,
    permission_group_name,
    route,
    method,
    permission_name,
    permission_description
from vw_permissions_by_group
where group_id = @id and permission_id is not null
order by permission_id