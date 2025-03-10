select distinct
    ID,
    route,
    method,
    visibility,
    property_path,
    read_right,
    write_right
from vw_user_all_permissions
where ID = @user
  and REPLACE(route, ':id', ISNULL(@id,'')) like
      case when CHARINDEX('?', @route) > 0 then
               LEFT(@route, CHARINDEX('?', @route) - 1)
           else
               '%' + @route + '%'
          end