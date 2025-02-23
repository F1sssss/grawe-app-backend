WITH recursive_groups AS (
    -- Start with the specified group
    SELECT id, name, level_type, parent_id
    FROM gr_hierarchy_groups
    WHERE id = @id

    UNION ALL

    -- Recursively get all child groups
    SELECT g.id, g.name, g.level_type, g.parent_id
    FROM gr_hierarchy_groups g
    JOIN recursive_groups rg ON g.parent_id = rg.id
)
SELECT DISTINCT
    rg.id AS group_id,
    rg.name AS group_name,
    rg.level_type,
    gv.vkto AS vkto_code,
    m.ma_vorname + ' ' + m.ma_zuname AS vkto_name
FROM
    recursive_groups rg
JOIN
    gr_hierarchy_vkto_mapping gv ON rg.id = gv.group_id
LEFT JOIN
    mitarbeiter m ON gv.vkto = m.ma_vkto
ORDER BY
    rg.level_type,
    rg.name,
    vkto_name