-- Check if user is in the group
IF NOT EXISTS (SELECT 1 FROM gr_user_hierarchy_groups WHERE user_id = @userId AND group_id = @groupId)
BEGIN
    THROW 50000, 'User is not in this group', 1;
END

-- Remove user from hierarchy group
DELETE FROM gr_user_hierarchy_groups
WHERE user_id = @userId AND group_id = @groupId

-- Return empty result to match existing pattern
SELECT * FROM gr_user_hierarchy_groups
WHERE user_id = @userId AND group_id = @groupId