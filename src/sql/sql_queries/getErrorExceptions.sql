
select i.*,CONCAT(u.Name, ' ', u.Last_Name) username from gr_greske_izuzetci i (nolock) left join users u on u.id= i.user_exception