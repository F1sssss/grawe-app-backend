if not exists (select 1 from gr_permission_groups (nolock)
where id=@id)
throw 50000, ' no-permission-group-with-id-found',2


delete from gr_permission_groups
where id=@id

select * from gr_permission_groups (nolock)
where id=@id