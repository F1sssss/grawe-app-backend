if not exists (select 1 from gr_permission_groups where id = @id)
begin
    throw 51000, 'permission-group-id-does-not-exist', 1
end

if(@name = '')
begin
    throw 51000, 'name-cant-be-empty', 1
end

update gr_permission_groups
set name = ISNULL(@name, name)
where id = @id

select id, name from gr_permission_groups where id = @id
