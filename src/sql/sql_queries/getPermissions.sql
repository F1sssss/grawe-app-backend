select distinct
u.ID,
p.route,
p.method,
p.visibility,
pl.property_path,
pp.read_right,
pp.write_right

from users u
left join gr_permission_groups pg ON u.role = pg.id
join gr_pairing_permission_groups_permission pg_p ON pg_p.id_permission_group=pg.permission
left join gr_permission p ON p.id=pg_p.id_permission
left join gr_permission_properties pp ON pp.permission_id=p.id
left join gr_property_lists pl ON pl.id = pp.property_path_id
where u.id=@user and REPLACE(p.route, ':id', ISNULL(@id,''))  like
case when CHARINDEX('?', @route)>0 then
LEFT(@route, CHARINDEX('?', @route)-1)
else
@route
end