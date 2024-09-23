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

if not exists
(
select * from gr_permission_groups p(nolock)
where id=@id_permission_group
)
begin
    throw 50001, 'Permission-group-not-found', 1;
end

if not exists
(
select * from gr_permission p(nolock)
where id=@id_permission
)
begin
    throw 50001, 'Permission-not-found', 1;
end


BEGIN TRANSACTION

insert into gr_permission_properties (read_right,write_right,group_id,permission_property_id)
select 1,1,@id_permission_group,id from gr_pairing_permisson_property_list
where id_permission = @id_permission

insert into gr_pairing_permission_groups_permission
values
(@id_permission_group,@id_permission)

COMMIT


  select
  distinct
  pp.id property_id,
  group_id,
  id_permission,
  id_permission_property,
  route,
  method,
  name,
  description,
  property_path

  from gr_permission_properties pp
  left join gr_pairing_permisson_property_list gpp on pp.permission_property_id=gpp.id
  left join gr_permission p on p.id=gpp.id_permission
  left join gr_property_lists pl on pl.id=gpp.id_permission_property
  where group_id=@id_permission_group and id_permission=@id_permission