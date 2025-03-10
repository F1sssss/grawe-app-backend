if (@id_permission_group is null or @id_permission_group=0)
    begin
        select distinct
            permission_id as id,
            route,
            method,
            name,
            description,
            0 as read_right,
            0 as write_right,
            property_path,
            property_id as id
        from vw_permission_by_id
        where permission_id = @id_permission
        order by property_id
    end
else
    begin
        select distinct
            permission_id as id,
            route,
            method,
            name,
            description,
            ISNULL(read_right, 0) as read_right,
            ISNULL(write_right, 0) as write_right,
            property_path,
            property_id as id
        from vw_permission_by_id
        where permission_id = @id_permission
          and (group_id = @id_permission_group or group_id is null)
        order by property_id
    end