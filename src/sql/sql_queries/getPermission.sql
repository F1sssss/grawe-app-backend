select distinct
p.id permission_id,
p.route,
p.method,
p.visibility,
p.name,
p.description,
pp.read_right,
pp.write_right,
pl.property_path,
pl.id property_id

from gr_permission_groups pg
join gr_pairing_permission_groups_permission pg_p ON pg_p.id_permission_group=pg.permission
left join gr_permission p ON p.id=pg_p.id_permission
left join gr_permission_properties pp ON pp.permission_id=p.id
left join gr_property_lists pl ON pl.id = pp.property_path_id
where permission_id=@id
order by property_id

