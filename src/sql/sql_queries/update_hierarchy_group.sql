-- Check if group exists
IF NOT EXISTS (SELECT 1 FROM gr_hierarchy_groups WHERE id = @id)
BEGIN
    THROW 50000, 'Hierarchy group not found', 1;
END

-- Validate parent_id if provided
IF @parentId IS NOT NULL AND NOT EXISTS (SELECT 1 FROM gr_hierarchy_groups WHERE id = @parentId)
BEGIN
    THROW 50000, 'Parent group does not exist', 1;
END

-- Update hierarchy group
UPDATE gr_hierarchy_groups
SET
    name = ISNULL(@name, name),
    level_type = ISNULL(@levelType, level_type),
    parent_id = ISNULL(@parentId, parent_id)
WHERE id = @id

-- Return the updated group
SELECT * FROM gr_hierarchy_groups WHERE id = @id