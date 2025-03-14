SELECT
    id,
    name,
    level_type,
    parent_id
FROM gr_hierarchy_groups
ORDER BY level_type, name;