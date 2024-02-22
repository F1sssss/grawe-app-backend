update gr_permission_groups
set name = ISNULL(@name, name)
where id = @id

select id, name from gr_permission_groups where id = @id
