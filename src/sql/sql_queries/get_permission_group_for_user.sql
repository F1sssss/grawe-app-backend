select distinct
u.ID user_id,
pg.id,
pg.name
from users u
left join gr_pairing_users_groups_permission pug on pug.user_id=u.ID
left join gr_permission_groups pg on pg.id=pug.permission_group_id
where u.ID=@id and pg.id is not null