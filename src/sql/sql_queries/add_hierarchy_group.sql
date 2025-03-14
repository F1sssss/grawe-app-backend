IF EXISTS (SELECT 1 FROM gr_hierarchy_groups WHERE name = @name AND level_type = @levelType)
BEGIN
    THROW 50000, 'Hierarchy group already exists', 1;
END

IF @parentId IS NOT NULL AND NOT EXISTS (SELECT 1 FROM gr_hierarchy_groups WHERE id = @parentId)
BEGIN
    THROW 50000, 'Parent group does not exist', 1;
END

INSERT INTO gr_hierarchy_groups (
                                 name,
                                 level_type,
                                 parent_id)
VALUES (
        @name,
        @levelType,
        @parentId
       )

-- Return the newly created group
SELECT * FROM gr_hierarchy_groups WHERE id = @@IDENTITY