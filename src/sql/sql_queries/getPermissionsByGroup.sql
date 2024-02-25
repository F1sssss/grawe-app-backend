select p.* from gr_pairing_permission_groups_permission  up
left join gr_permission p on p.id=up.id_permission
where up.id_permission_group=@id