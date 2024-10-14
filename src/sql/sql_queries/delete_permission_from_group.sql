if not exists(select * from gr_pairing_permission_groups_permission pl
              where id_permission_group=@id_permission_group and pl.id_permission=@id_permission)
begin
    throw 50001, 'Permission-not-found-in-group', 1;
end



begin transaction

delete from gr_permission_properties
where group_id=@id_permission_group
and exists (select 1 from gr_pairing_permisson_property_list ppp where gr_permission_properties.permission_property_id=ppp.id and ppp.id_permission=@id_permission)


delete from gr_pairing_permission_groups_permission
where  id_permission_group=@id_permission_group and id_permission=@id_permission

commit

select * from gr_pairing_permisson_property_list pl
left join gr_permission_properties pp on pp.permission_property_id=pl.id
left join gr_pairing_permission_groups_permission pg on pg.id_permission=pl.id_permission
where id_permission_group=@id_permission_group and pl.id_permission=@id_permission

