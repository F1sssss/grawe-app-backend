if (@name is null or @name = '')
begin
    throw 50000, ' no-name-provided',2
end

if exists (select 1 from gr_permission_groups where name = @name)
begin
    throw 50000, 'permission-group-already-exists',2
end


insert into gr_permission_groups (name)
values (@name);


select id, name from gr_permission_groups where id = @@identity;
