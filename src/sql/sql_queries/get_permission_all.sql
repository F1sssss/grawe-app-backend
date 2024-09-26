select distinct
p.id permission_id,
p.route,
p.method,
p.visibility,
p.name,
p.description

from gr_permission p

order by permission_id