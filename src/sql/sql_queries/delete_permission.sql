if not exists (select 1 from gr_permission where id = @id)
begin
    throw 51000, 'Permission-not-found', 1;
    return
end

BEGIN TRANSACTION

delete from gr_permission
where id = @id

delete from gr_pairing_permission_groups_permission
where id_permission = @id

delete from gr_pairing_permisson_property_list
where id_permission = @id

COMMIT

select * from gr_permission
where id = @id