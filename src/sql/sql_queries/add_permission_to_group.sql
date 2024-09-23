if not exists (select 1 from gr_permission where id = @id_permission)
    begin
        throw 50000, 'Permission-not-found', 1;
    end

if not exists (select 1 from gr_permission_groups where id = @id_permission_group)
    begin
        throw 50000, 'Permission-group-not-found', 1;
    end

if exists (select 1 from gr_pairing_permission_groups_permission where id_permission_group = @id_permission_group and id_permission = @id_permission)
    begin
        throw 50000, 'permission-group-already-exists',2
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
