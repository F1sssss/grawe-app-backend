select up.permission_group_id,up.user_id,p.* from gr_pairing_users_groups_permission  up
left join gr_permission p on p.id=up.permission_group_id
where up.permission_group_id=@id