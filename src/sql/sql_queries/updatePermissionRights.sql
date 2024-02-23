if (select count(*) from gr_permission_properties where property_path_id = @id) = 0
begin
    throw 51000, 'property_path_id is required', 1
end

update gr_permission_properties
set read_right = isnull(@read, read_right),
    write_right = isnull(@write, write_right)
where property_path_id = @id


select property_path_id,read_right,write_right from gr_permission_properties pp
left join gr_property_lists pl on pp.property_path_id = pl.id
where property_path_id = @id
