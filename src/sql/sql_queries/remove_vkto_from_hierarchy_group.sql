IF NOT EXISTS (SELECT 1 FROM gr_hierarchy_vkto_mapping WHERE group_id = @groupId AND vkto = @vkto)
BEGIN
    THROW 50000, 'VKTO is not in this group', 1;
END


DELETE FROM gr_hierarchy_vkto_mapping
WHERE group_id = @groupId AND vkto = @vkto


SELECT group_id, vkto FROM gr_hierarchy_vkto_mapping
WHERE group_id = @groupId AND vkto = @vkto;