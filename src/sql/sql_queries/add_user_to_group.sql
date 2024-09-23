if exists (select * from gr_pairing_users_groups_permission where user_id=@user and permission_group_id=@group)
begin

    throw 50000, 'User-already-exists-in-the-group', 1;

end

if not exists (select 1 from gr_permission_groups where id = @group)
begin
    throw 50001, 'group-id-does-not-exist', 1;
end

if not exists (select 1 from users where id = @user)
begin
    throw 51000, 'user-id-does-not-exist', 1;
end


insert into gr_pairing_users_groups_permission
values
(@user,@group)


select *
from gr_pairing_users_groups_permission
where user_id=@user and permission_group_id=@group