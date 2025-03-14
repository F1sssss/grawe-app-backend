if @route is null or @route = ''
begin
    throw 50000, 'Route is required', 1;
end

if @method is null or @method = ''
begin
    throw 50000, 'Method is required', 1;
end

if exists (select * from gr_permission where route=@route and method=@method)
begin
    throw 50000, 'Permission already exists', 1;
end


insert into gr_permission (
                           route,
                           method,
                           name ,
                           description,
                           visibility
)
values (
        @route,
        @method,
        @name,
        @description,
        @visibility
       )


select * from gr_permission (nolock)
where id = @@identity
