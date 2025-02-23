-- Check if group exists
IF NOT EXISTS (SELECT 1 FROM gr_hierarchy_groups WHERE id = @id)
BEGIN
    THROW 50000, 'Hierarchy group not found', 1;
END

-- Check if group has child groups
IF EXISTS (SELECT 1 FROM gr_hierarchy_groups WHERE parent_id = @id)
BEGIN
    THROW 50000, 'Cannot delete group with child groups', 1;
END

-- Check if group has associated VKTO mappings
IF EXISTS (SELECT 1 FROM gr_hierarchy_vkto_mapping WHERE group_id = @id)
BEGIN
    THROW 50000, 'Cannot delete group with VKTO mappings', 1;
END

-- Check if group has associated users
IF EXISTS (SELECT 1 FROM gr_user_hierarchy_groups WHERE group_id = @id)
BEGIN
    THROW 50000, 'Cannot delete group with associated users', 1;
END

-- Delete the group
DELETE FROM gr_hierarchy_groups WHERE id = @id

-- Return empty result to match existing pattern
SELECT * FROM gr_hierarchy_groups WHERE id = @id