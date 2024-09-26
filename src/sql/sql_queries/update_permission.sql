if @id is null or @id = 0
begin
    throw 51000, 'id is required', 1
end

if @name=''
begin
    throw 51000, 'name cant be empty', 1
end

if not exists(select 1 from gr_permission where id = @id)
begin
    throw 51000, 'permission not found', 1
end

update gr_permission
set name = isnull(@name, name),
    description = isnull(@description, description)
where id = @id


select * from gr_permission where id = @id

