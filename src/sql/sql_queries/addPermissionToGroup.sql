if @id_permission_group is null or @id_permission_group = 0
    begin
        throw 50000, 'id_permission_group is null or 0', 1;
    end

if @id_permission is null or @id_permission = 0
    begin
        throw 50000, 'id_permission is null or 0', 1;
    end

insert into gr_pairing_permission_groups_permission
    (id_permission_group, id_permission)
values
    (@id_permission_group, @id_permission);


select
pg.id permission_group_id,
pg.name permission_group_name,
p.method,
p.route,
p.name,
p.description,
pg_p.id_permission
from gr_permission_groups pg
left join gr_pairing_permission_groups_permission pg_p ON pg_p.id_permission_group=pg.id
left join gr_permission p ON p.id=pg_p.id_permission
where pg.id = @id_permission_group
