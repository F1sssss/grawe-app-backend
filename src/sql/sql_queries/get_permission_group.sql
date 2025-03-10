select
    permission_id as id,
    permission_group_name as name,
    route,
    method,
    permission_name as name,
    permission_description as description
from vw_permissions_by_group
where group_id = @id and permission_id is not null
order by permission_id