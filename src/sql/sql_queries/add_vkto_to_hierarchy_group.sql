IF NOT EXISTS (SELECT 1 FROM vertrag WHERE vtg_pol_vkto = @vkto)
BEGIN
    THROW 50000, 'VKTO not found', 1;
END


IF NOT EXISTS (SELECT 1 FROM gr_hierarchy_groups WHERE id = @groupId)
BEGIN
    THROW 50000, 'Hierarchy group not found', 1;
END


IF EXISTS (SELECT 1 FROM gr_hierarchy_vkto_mapping WHERE vkto = @vkto)
BEGIN

    DELETE FROM gr_hierarchy_vkto_mapping
    WHERE vkto = @vkto;

END


INSERT INTO gr_hierarchy_vkto_mapping (group_id, vkto)
VALUES (@groupId, @vkto)


SELECT group_id, vkto FROM gr_hierarchy_vkto_mapping
WHERE group_id = @groupId AND vkto = @vkto;

