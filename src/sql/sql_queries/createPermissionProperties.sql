if exists
(
select * from gr_permission_properties pp(nolock)
left join gr_permission_groups pg on pg.id=pp.group_id
left join gr_pairing_permission_groups_permission ppg on ppg.id_permission_group=pg.id
left join gr_permission p on p.id=ppg.id_permission
where id_permission_group=@id_permission_group and id_permission=@id_permission
)

begin
    throw 50000, 'Permission already exists', 1;
end


BEGIN TRANSACTION

insert into gr_permission_properties (read_right,write_right,group_id,permission_property_id)
select 0,0,@id_permission_group,id from gr_pairing_permisson_property_list
where id_permission = @id_permission

insert into gr_pairing_permission_groups_permission
values
(@id_permission_group,@id_permission)

COMMIT

select
p.route,
pl.property_path,
pp.read_right,
pp.write_right
  from gr_permission_properties pp
  left join gr_pairing_permisson_property_list gpp on pp.permission_property_id=gpp.id
  left join gr_permission p on p.id=gpp.id_permission
  left join gr_property_lists pl on pl.id=gpp.id_permission_property
