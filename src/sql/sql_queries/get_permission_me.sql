select distinct
    ID,
    route,
    method,
    visibility,
    property_path,
    read_right,
    write_right
from vw_user_all_permissions
where ID = @id