IF NOT EXISTS (SELECT 1 FROM gr_pairing_permisson_property_list WHERE id_permission = @permission_id AND id_permission_property = @property_id)
    BEGIN
        THROW 50000, 'Permission-property-not-found', 1;
    END

BEGIN TRANSACTION

DELETE FROM gr_permission_properties
WHERE permission_property_id IN (
    SELECT id
    FROM gr_pairing_permisson_property_list
    WHERE id_permission = @permission_id AND id_permission_property = @property_id
)


DELETE FROM gr_pairing_permisson_property_list
WHERE id_permission = @permission_id AND id_permission_property = @property_id

COMMIT

SELECT * FROM gr_pairing_permisson_property_list
WHERE id_permission = @permission_id AND id_permission_property = @property_id