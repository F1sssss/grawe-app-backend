select
p.id property_id,
p.route,
p.method,
p.name,
p.description,
pp.read_right,
pp.write_right,
pl.property_path,
pl.id

from gr_permission p
left join gr_pairing_permisson_property_list ppl on ppl.id_permission=p.id
left join gr_property_lists pl on pl.id=ppl.id_permission_property
left join gr_permission_properties pp on pp.permission_property_id=ppl.id
where p.id=@id
order by p.id
