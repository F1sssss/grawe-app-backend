USE [GRAWE_DEV]
GO

-- Permission System Views Creation Script (Using Original Table Names)
-- These views simplify your permission system queries while maintaining the original table structure

-- View for permission details with property pairings
CREATE OR ALTER VIEW vw_permission_details AS
SELECT 
    p.id AS permission_id,
    p.route,
    p.method,
    p.visibility,
    p.name,
    p.description,
    ppl.id AS pairing_id,
    ppl.id_permission_property,
    pl.property_path
FROM 
    gr_permission p
LEFT JOIN 
    gr_pairing_permisson_property_list ppl ON ppl.id_permission = p.id
LEFT JOIN 
    gr_property_lists pl ON pl.id = ppl.id_permission_property;
GO

-- View for permission group details
CREATE OR ALTER VIEW vw_permission_group_details AS
SELECT 
    pg.id AS group_id,
    pg.name AS group_name,
    pgp.id_permission,
    (SELECT COUNT(*) FROM gr_pairing_users_groups_permission upg WHERE upg.permission_group_id = pg.id) AS user_count
FROM 
    gr_permission_groups pg
LEFT JOIN 
    gr_pairing_permission_groups_permission pgp ON pgp.id_permission_group = pg.id;
GO

-- View for group-permission-property rights
CREATE OR ALTER VIEW vw_permission_rights AS
SELECT 
    pp.group_id,
    ppl.id_permission,
    ppl.id_permission_property,
    pl.property_path,
    pp.read_right,
    pp.write_right
FROM 
    gr_permission_properties pp
JOIN 
    gr_pairing_permisson_property_list ppl ON pp.permission_property_id = ppl.id
JOIN 
    gr_property_lists pl ON pl.id = ppl.id_permission_property;
GO

-- View for user permissions and rights
CREATE OR ALTER VIEW vw_user_permissions AS
SELECT 
    u.ID AS user_id,
    pup.permission_group_id,
    pg.name AS group_name,
    p.id AS permission_id,
    p.route,
    p.method, 
    p.visibility,
    pl.id AS property_id,
    pl.property_path,
    pp.read_right,
    pp.write_right
FROM 
    users u
JOIN 
    gr_pairing_users_groups_permission pup ON pup.user_id = u.ID
JOIN 
    gr_permission_groups pg ON pg.id = pup.permission_group_id
JOIN 
    gr_pairing_permission_groups_permission pgp ON pgp.id_permission_group = pup.permission_group_id
JOIN 
    gr_permission p ON p.id = pgp.id_permission
LEFT JOIN 
    gr_pairing_permisson_property_list ppl ON ppl.id_permission = p.id
LEFT JOIN 
    gr_property_lists pl ON pl.id = ppl.id_permission_property
LEFT JOIN 
    gr_permission_properties pp ON pp.permission_property_id = ppl.id AND pp.group_id = pup.permission_group_id;
GO

-- View for all permissions (simplifies get_permission_all.sql)
CREATE OR ALTER VIEW vw_all_permissions AS
SELECT DISTINCT
    p.id AS permission_id,
    p.route,
    p.method,
    p.visibility,
    p.name,
    p.description
FROM 
    gr_permission p;
GO

-- View for permission by ID with optional group context (simplifies get_permission.sql)
CREATE OR ALTER VIEW vw_permission_by_id AS
SELECT 
    p.id AS permission_id,
    p.route,
    p.method,
    p.name,
    p.description,
    pp.group_id,
    ISNULL(pp.read_right, 0) AS read_right,
    ISNULL(pp.write_right, 0) AS write_right,
    pl.property_path,
    pl.id AS property_id
FROM 
    gr_permission p
LEFT JOIN 
    gr_pairing_permisson_property_list ppl ON ppl.id_permission = p.id
LEFT JOIN 
    gr_property_lists pl ON pl.id = ppl.id_permission_property
LEFT JOIN 
    gr_permission_properties pp ON pp.permission_property_id = ppl.id;
GO

-- View for permissions by group (simplifies get_permission_by_group.sql)
CREATE OR ALTER VIEW vw_permissions_by_group AS
SELECT
    p.id AS permission_id,
    pg.id AS group_id,
    pg.name AS permission_group_name,
    p.route,
    p.method,
    p.name AS permission_name,
    p.description AS permission_description
FROM 
    gr_permission_groups pg
LEFT JOIN 
    gr_pairing_permission_groups_permission ppp ON ppp.id_permission_group = pg.id
LEFT JOIN 
    gr_permission p ON p.id = ppp.id_permission
WHERE 
    p.id IS NOT NULL;
GO

-- View for all groups (simplifies get_permission_groups_all.sql)
CREATE OR ALTER VIEW vw_all_permission_groups AS
SELECT 
    pg.id,
    pg.name,
    ISNULL((SELECT COUNT(*) FROM gr_pairing_users_groups_permission up
           WHERE up.permission_group_id = pg.id), 0) AS users
FROM 
    gr_permission_groups pg;
GO

-- View for user's permission groups (simplifies get_permission_group_for_user.sql)
CREATE OR ALTER VIEW vw_user_permission_groups AS
SELECT DISTINCT
    u.ID AS user_id,
    pg.id,
    pg.name
FROM 
    users u
LEFT JOIN 
    gr_pairing_users_groups_permission pug ON pug.user_id = u.ID
LEFT JOIN 
    gr_permission_groups pg ON pg.id = pug.permission_group_id
WHERE 
    pg.id IS NOT NULL;
GO

-- View for user permissions (simplifies get_permission_me.sql)
CREATE OR ALTER VIEW vw_user_all_permissions AS
SELECT DISTINCT
    u.ID,
    p.route,
    p.method,
    p.visibility,
    pl.property_path,
    pp.read_right,
    pp.write_right
FROM 
    users u
JOIN 
    gr_pairing_users_groups_permission pup ON pup.user_id = u.ID
LEFT JOIN 
    gr_permission_groups pg ON pg.id = pup.permission_group_id
JOIN 
    gr_pairing_permission_groups_permission pg_p ON pg_p.id_permission_group = pg.id
LEFT JOIN 
    gr_permission p ON p.id = pg_p.id_permission
LEFT JOIN 
    gr_pairing_permisson_property_list ppl ON ppl.id_permission = p.id
LEFT JOIN 
    gr_property_lists pl ON pl.id = ppl.id_permission_property
LEFT JOIN 
    gr_permission_properties pp ON pp.permission_property_id = ppl.id AND pp.group_id = pup.permission_group_id;
GO


-- Create optimized indexes for better view performance using proper conditional logic

-- Check if indexes exist and create them if they don't
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_gr_permission_id' AND object_id = OBJECT_ID('gr_permission'))
BEGIN
    CREATE INDEX IX_gr_permission_id ON gr_permission(id);
    PRINT 'Created index: IX_gr_permission_id';
END

IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_gr_pairing_permisson_property_list_permission_id' AND object_id = OBJECT_ID('gr_pairing_permisson_property_list'))
BEGIN
    CREATE INDEX IX_gr_pairing_permisson_property_list_permission_id ON gr_pairing_permisson_property_list(id_permission);
    PRINT 'Created index: IX_gr_pairing_permisson_property_list_permission_id';
END

IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_gr_pairing_permission_groups_permission_group_id' AND object_id = OBJECT_ID('gr_pairing_permission_groups_permission'))
BEGIN
    CREATE INDEX IX_gr_pairing_permission_groups_permission_group_id ON gr_pairing_permission_groups_permission(id_permission_group);
    PRINT 'Created index: IX_gr_pairing_permission_groups_permission_group_id';
END

IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_gr_pairing_users_groups_permission_user_id' AND object_id = OBJECT_ID('gr_pairing_users_groups_permission'))
BEGIN
    CREATE INDEX IX_gr_pairing_users_groups_permission_user_id ON gr_pairing_users_groups_permission(user_id);
    PRINT 'Created index: IX_gr_pairing_users_groups_permission_user_id';
END

IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_gr_permission_properties_group_id' AND object_id = OBJECT_ID('gr_permission_properties'))
BEGIN
    CREATE INDEX IX_gr_permission_properties_group_id ON gr_permission_properties(group_id);
    PRINT 'Created index: IX_gr_permission_properties_group_id';
END