select distinct
    id,
    name permission_group_name,
    users
from vw_all_permission_groups
where id = @id