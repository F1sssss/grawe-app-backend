WITH recursive_groups AS (
    -- Start with the specified group
    SELECT id, level_type, parent_id
    FROM gr_hierarchy_groups
    WHERE id = @id

    UNION ALL

    -- Get all child groups
    SELECT g.id, g.level_type, g.parent_id
    FROM gr_hierarchy_groups g
    JOIN recursive_groups rg ON g.parent_id = rg.id
)
SELECT DISTINCT gv.vkto
FROM recursive_groups rg
JOIN gr_hierarchy_vkto_mapping gv ON rg.id = gv.group_id;