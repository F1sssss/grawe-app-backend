 select
 p.id permission_id,
 pg.name permission_group_name,
 p.route,
 p.method,
 p.name permission_name,
 p.description permission_description
 from gr_permission_groups pg
 join gr_pairing_permission_groups_permission pg_p ON pg_p.id_permission_group=pg.permission
 left join gr_permission p ON p.id=pg_p.id_permission
 where pg.id=@id
 order by pg.id