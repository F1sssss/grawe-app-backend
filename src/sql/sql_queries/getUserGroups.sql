select distinct
u.ID user_id,
pg.id,
pg.name
from gr_pairing_users_groups_permission pug
join users u on u.ID=pug.user_id
join gr_permission_groups pg ON u.role = pg.id
where u.ID= @id