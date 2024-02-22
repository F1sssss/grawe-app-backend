delete gr_pairing_permission_groups_permission
where id_permission = @id_permission and id_permission_group = @id_permission_group

select id_permission, id_permission_group
from gr_pairing_permission_groups_permission (nolock)
where id_permission = @id_permission and id_permission_group = @id_permission_group
