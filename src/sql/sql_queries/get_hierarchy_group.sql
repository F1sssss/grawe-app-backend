SELECT id, name, level_type, parent_id
FROM gr_hierarchy_groups
WHERE id = @id;