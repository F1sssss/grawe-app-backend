select
i.*,
CONCAT(u.Name, ' ', u.Last_Name) username
from gr_error_exceptions i (nolock)
left join users u on u.id= i.user_exception