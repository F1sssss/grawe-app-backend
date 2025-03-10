SELECT
    pp.id,
    pp.id_permission,
    pp.id_permission_property,
    p.route,
    p.method,
    p.name AS permission_name,
    pl.property_path
FROM gr_pairing_permisson_property_list pp
         JOIN gr_permission p ON p.id = pp.id_permission
         JOIN gr_property_lists pl ON pl.id = pp.id_permission_property
WHERE pp.id_permission = @permission_id
ORDER BY pl.property_path