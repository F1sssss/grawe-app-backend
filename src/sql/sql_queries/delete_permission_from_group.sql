begin transaction

delete gr_permission_properties
where exists (
select * from gr_pairing_permisson_property_list pl
left join gr_permission_properties pp on pp.permission_property_id=pl.id
left join gr_pairing_permission_groups_permission pg on pg.id_permission=pl.id_permission
where id_permission_group=@id_permission_group and pl.id_permission=@id_permission and pp.id=gr_permission_properties.id
)


delete from gr_pairing_permission_groups_permission
where  id_permission_group=@id_permission_group and id_permission=@id_permission

commit

select * from gr_pairing_permisson_property_list pl
left join gr_permission_properties pp on pp.permission_property_id=pl.id
left join gr_pairing_permission_groups_permission pg on pg.id_permission=pl.id_permission
where id_permission_group=@id_permission_group and pl.id_permission=@id_permission

