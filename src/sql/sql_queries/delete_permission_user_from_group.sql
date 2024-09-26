if not exists (select 1 from gr_pairing_users_groups_permission where user_id=@user and permission_group_id=@group)
begin
    throw 50000, 'User does not have permission in this group', 1
end


delete from gr_pairing_users_groups_permission
where user_id=@user and permission_group_id=@group


select *
from gr_pairing_users_groups_permission
where user_id=@user and permission_group_id=@group
