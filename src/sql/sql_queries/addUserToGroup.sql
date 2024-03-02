if exists (select * from gr_pairing_users_groups_permission where user_id=@user and permission_group_id=@group)
begin

    throw 50000, 'User already in this group', 1;

end

insert into gr_pairing_users_groups_permission
values
(@user,@group)


select *
from gr_pairing_users_groups_permission
where user_id=@user and permission_group_id=@group