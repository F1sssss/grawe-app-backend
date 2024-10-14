 select
 p.id permission_id,
 pg.name permission_group_name,
 p.route,
 p.method,
 p.name permission_name,
 p.description permission_description
 from gr_permission_groups pg
 left join gr_pairing_permission_groups_permission ppp on ppp.id_permission_group=pg.id
 left join gr_permission p on p.id=ppp.id_permission
 where pg.id=@id and p.id is not null
 order by pg.id