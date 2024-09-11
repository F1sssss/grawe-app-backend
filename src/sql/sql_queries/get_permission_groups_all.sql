select id,
name,
ISNULL((select count(*) from gr_pairing_users_groups_permission up
where up.permission_group_id=pg.id),0) users
from gr_permission_groups pg
order by id