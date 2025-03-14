IF NOT EXISTS (SELECT 1 FROM gr_user_hierarchy_groups WHERE user_id = @userId AND group_id = @groupId)
BEGIN
    THROW 50000, 'User is not in this group', 1;
END

DELETE FROM gr_user_hierarchy_groups
WHERE user_id = @userId AND group_id = @groupId

SELECT * FROM gr_user_hierarchy_groups
WHERE user_id = @userId AND group_id = @groupId