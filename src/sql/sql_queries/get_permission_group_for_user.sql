select distinct
    user_id,
    id,
    name
from vw_user_permission_groups
where user_id = 1