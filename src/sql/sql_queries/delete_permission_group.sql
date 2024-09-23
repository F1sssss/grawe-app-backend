if not exists (select 1 from gr_permission_groups (nolock)
where id=@id)
throw 50000, ' no-permission-group-with-id-found',2


BEGIN TRANSACTION

delete from gr_permission_groups
where id=@id

delete from gr_pairing_users_groups_permission
where permission_group_id=@id

delete from gr_pairing_permission_groups_permission
where id_permission_group=@id

COMMIT

select * from gr_permission_groups (nolock)
where id=@id