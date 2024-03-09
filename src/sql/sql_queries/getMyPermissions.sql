select distinct
u.ID,
p.route,
p.method,
p.visibility,
pl.property_path,
pp.read_right,
pp.write_right

from users u
join gr_pairing_users_groups_permission pup on pup.user_id=u.ID
left join gr_permission_groups pg ON pup.permission_group_id = pg.id
join gr_pairing_permission_groups_permission pg_p ON pg_p.id_permission_group=pg.permission
left join gr_permission p ON p.id=pg_p.id_permission
left join gr_pairing_permisson_property_list ppp on ppp.id_permission=p.id
left join gr_property_lists pl ON pl.id = ppp.id_permission_property
left join gr_permission_properties pp on pp.permission_property_id=ppp.id
where u.id=@id