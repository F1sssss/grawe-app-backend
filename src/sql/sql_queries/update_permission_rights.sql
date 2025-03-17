if not exists (select *  from gr_permission_properties pp
 where permission_property_id = @id and group_id = @group)
begin

    throw 50000, 'Permission-not-found', 1;

end

if (@read is not null and @read not in (0,1) or @write is not null and @write not in (0,1))
begin

    throw 50000, 'Invalid-value-for-read-or-write', 1;

end

update pp
set read_right = isnull(@read, read_right),
    write_right = isnull(@write, write_right)
from gr_permission_properties pp
left join gr_pairing_permisson_property_list pl on pp.permission_property_id=pl.id
where id_permission_property = @id and group_id = @group


select id_permission_property,ppl.property_path,read_right,write_right,pp.group_id from gr_permission_properties pp
left join gr_pairing_permisson_property_list pl on pp.permission_property_id=pl.id
left join gr_property_lists ppl on ppl.id=pl.id_permission_property
where id_permission_property = @id
