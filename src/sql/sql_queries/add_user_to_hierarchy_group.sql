-- Check if user exists
IF NOT EXISTS (SELECT 1 FROM users WHERE id = @userId)
BEGIN
    THROW 50000, 'User not found', 1;
END

-- Check if group exists
IF NOT EXISTS (SELECT 1 FROM gr_hierarchy_groups WHERE id = @groupId)
BEGIN
    THROW 50000, 'Hierarchy group not found', 1;
END

BEGIN TRANSACTION

-- Check if user is already in a group
IF EXISTS (SELECT 1 FROM gr_user_hierarchy_groups WHERE user_id = @userId)
BEGIN

    DELETE FROM gr_user_hierarchy_groups
    WHERE user_id = @userId

END

-- Add user to hierarchy group
INSERT INTO gr_user_hierarchy_groups (user_id, group_id)
VALUES (@userId, @groupId)


COMMIT TRANSACTION

-- Return the added mapping
SELECT * FROM gr_user_hierarchy_groups
WHERE user_id = @userId AND group_id = @groupId