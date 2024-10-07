if (@id_permission_group is null or @id_permission_group=0)

begin

select distinct 
p.id permission_id,
p.route,
p.method,
p.name,
p.description,
0 read_right,
0 write_right,
pl.property_path,
pl.id

from gr_permission p
left join gr_pairing_permisson_property_list ppl on ppl.id_permission=p.id
left join gr_property_lists pl on pl.id=ppl.id_permission_property
left join gr_permission_properties pp on pp.permission_property_id=ppl.id
where p.id=@id_permission --and group_id=@id_permission_group
order by p.id


end

else

begin

select distinct
p.id permission_id,
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
left join gr_pairing_permission_groups_permission ppgp on ppgp.id_permission=p.id
where p.id=@id_permission and id_permission_group=@id_permission_group
order by p.id


end

