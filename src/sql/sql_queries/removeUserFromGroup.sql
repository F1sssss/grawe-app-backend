

delete from gr_pairing_users_groups_permission
where user_id=@user and permission_group_id=@group


select *
from gr_pairing_users_groups_permission
where user_id=@user and permission_group_id=@group
