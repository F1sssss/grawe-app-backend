const DBConnection = require('../../sql/DBConnection');
const AccessControlQueries = require('../../sql/Queries/accessControlQueries');
const sql = require('../../tests/sql_test');

describe('Access control queries', () => {
  let permissionId;
  let groupID;
  let user_id;
  let property_id;

  beforeAll(() => {
    connection = new DBConnection(sql);
    jest.setTimeout(500000);
  });

  it('should connect to the test database', async () => {
    const consoleSpy = jest.spyOn(console, 'log');
    await connection.connect();
    expect(consoleSpy).toHaveBeenCalledWith('🔒 Connected to MSSQL database');
    consoleSpy.mockRestore();
  }, 50000);

  it('should successfully create a new permission', async () => {
    const permission = {
      route: '/api/test',
      visibility: 1,
      method: 'GET',
      name: 'Test Permission',
      description: 'This is a test permission',
    };

    const result = await AccessControlQueries.createPermission(permission);

    permissionId = result.permissions.id;

    const queryResult = await connection.executeQuery('SELECT * FROM gr_permission WHERE route = @route', [
      { name: 'route', type: 'VARCHAR', value: '/api/test' },
    ]);

    expect(result.statusCode).toBe(201);
    expect(result.permissions).toBeDefined();
    expect(queryResult.route).toBe('/api/test');
  });

  it('should throw an error if permission already exists', async () => {
    const permission = {
      route: '/api/test',
      visibility: 1,
      method: 'GET',
      name: 'Test Permission',
      description: 'This is a test permission',
    };

    await expect(AccessControlQueries.createPermission(permission)).rejects.toThrow();
  });

  it('should throw an error if route or method is missing', async () => {
    const invalidPermission = {
      visibility: 1,
      method: '',
      name: 'Test Permission',
      description: 'This is a test permission',
    };

    await expect(AccessControlQueries.createPermission(invalidPermission)).rejects.toThrow('Route is required');
  });

  it('should get a permission by id', async () => {
    const permission = await AccessControlQueries.getPermission(permissionId);
    expect(permission.statusCode).toBe(200);
    expect(permission.permissions).toBeDefined();
  });

  it('should get all permissions', async () => {
    const permissions = await AccessControlQueries.getPermissions();
    expect(permissions.statusCode).toBe(200);
    expect(permissions.permissions).toBeDefined();
    expect(Array.isArray(permissions.permissions)).toBe(true);
  });

  it('should update the name and description of an existing permission', async () => {
    const updated_permission = {
      route: '/api/test',
      visibility: 1,
      method: 'GET',
      name: 'Updated Test Permission',
      description: 'This is an updated test permission',
    };

    const result = await AccessControlQueries.updatePermission(permissionId, updated_permission);

    expect(result.statusCode).toBe(200);
    expect(result.permissions).toMatchObject({
      name: 'Updated Test Permission',
      description: 'This is an updated test permission',
    });
  });

  it('should throw an error if you try to update a permission that does not exist', async () => {
    const updated_permission = {
      route: '/api/test',
      visibility: 1,
      method: 'GET',
      name: 'Updated Test Permission',
      description: 'This is an updated test permission',
    };

    await expect(AccessControlQueries.updatePermission(9999, updated_permission)).rejects.toThrow();
  });

  it('should throw an error if you try to update a permission with empty name field', async () => {
    const updated_permission = {
      route: '/api/test',
      visibility: 1,
      method: 'GET',
      name: '',
      description: 'This is an updated test permission',
    };

    await expect(AccessControlQueries.updatePermission(permissionId, updated_permission)).rejects.toThrow();
  });

  it('should create a permission group', async () => {
    const result = await AccessControlQueries.createGroup('Test Group');
    groupID = result.permission_group.id;

    expect(result.statusCode).toBe(201);
    expect(result.permission_group).toMatchObject({
      name: 'Test Group',
    });
  });

  it('should throw an error if group already exists', async () => {
    await expect(AccessControlQueries.createGroup('Test Group')).rejects.toThrow();
  });

  it('should throw an error if group name is missing', async () => {
    await expect(AccessControlQueries.createGroup('')).rejects.toThrow();
  });

  it('should get a group by id', async () => {
    const group = await AccessControlQueries.getGroup(groupID);
    expect(group.statusCode).toBe(200);
    expect(group.permission_group.permission_group_name).toBe('Test Group');
  });

  it('should update an existing group', async () => {
    const result = await AccessControlQueries.updateGroup(groupID, 'Updated Test Group');

    expect(result.statusCode).toBe(200);
    expect(result.permission_group).toMatchObject({
      name: 'Updated Test Group',
    });
  });

  it('should throw an error if you try to update a group that does not exist', async () => {
    await expect(AccessControlQueries.updateGroup(9999, 'Non-existent Group')).rejects.toThrow();
  });

  it('should throw an error if you try to update a group with a blank name', async () => {
    await expect(AccessControlQueries.updateGroup(groupID, '')).rejects.toThrow();
  });

  it('should throw an error if you try to add a permission that doesnt exist to a group', async () => {
    await expect(AccessControlQueries.addPermissionToGroup(groupID, 9999)).rejects.toThrow();
  });

  it('should throw an error if you try to add a permission to a group that does not exist', async () => {
    await expect(AccessControlQueries.addPermissionToGroup(9999, permissionId)).rejects.toThrow();
  });

  it('should add a permission to a group', async () => {
    const result = await AccessControlQueries.addPermissionToGroup(groupID, permissionId);
    expect(result.statusCode).toBe(200);
    expect(result.permissions).toBeDefined();
  });

  it('should add permission property to a group', async () => {
    const result = await AccessControlQueries.createPermissionProperties(permissionId, groupID);
    expect(result.statusCode).toBe(201);
    expect(result.permissions).toBeDefined();
  });

  it('should throw an error if you try to add a permission property to a group that does not exist', async () => {
    await expect(AccessControlQueries.createPermissionProperties(9999, permissionId)).rejects.toThrow();
  });

  it('should throw an error if you try to add a permission property to a permission that already has exist', async () => {
    await expect(AccessControlQueries.createPermissionProperties(groupID, permissionId)).rejects.toThrow();
  });

  it('should remove permission property from a group', async () => {
    const result = await AccessControlQueries.removePermissionFromGroup(groupID, permissionId);
    expect(result.statusCode).toBe(200);
    expect(result.message).toBe('Permission removed from group!');
  });

  it('should throw a error if permission prpoerty doesnt exist in the group', async () => {
    await expect(AccessControlQueries.removePermissionFromGroup(groupID, permissionId)).rejects.toThrow();
  });

  it('should create a dummy property for testing purposes', async () => {
    const result = await connection.executeQuery(
      'INSERT INTO gr_permission_properties (read_right, write_right, group_id, permission_property_id) VALUES (0, 0, @group_id, @permission_property_id); select id from gr_permission_properties where group_id = @group_id and permission_property_id = @permission_property_id',
      [
        { name: 'group_id', type: 'INT', value: groupID },
        { name: 'permission_property_id', type: 'INT', value: permissionId },
      ],
    );
    expect(result).toBeDefined();
    property_id = result.id;
  });

  it('should get a permission by id and group', async () => {
    const permission = await AccessControlQueries.getPermission(permissionId, groupID);
    permission_object = permission.permissions;
    expect(permission.statusCode).toBe(200);
    expect(permission.permissions).toBeDefined();
  });

  it('should throw an error when updating permission rights of a permission that does not exist', async () => {
    expect(AccessControlQueries.updatePermissionRights(9999, groupID, 1)).rejects.toThrow();
  });

  it('should throw an error when updating permission rights of a group that does not exist', async () => {
    expect(AccessControlQueries.updatePermissionRights(permissionId, 9999, 1)).rejects.toThrow();
  });

  it('should throw an error if you try to update permission rights with an invalid value', async () => {
    expect(AccessControlQueries.updatePermissionRights(permissionId, groupID, 3, 1)).rejects.toThrow();
  });

  it('should throw an error if you try to update permission rights with an invalid value', async () => {
    expect(AccessControlQueries.updatePermissionRights(permissionId, groupID, 1, 2)).rejects.toThrow();
  });

  it('should update permission rights of a permission', async () => {
    const result = await AccessControlQueries.updatePermissionRights(permissionId, groupID, 1, 1);

    expect(result.statusCode).toBe(200);
    expect(result.permissions).toBeDefined();
  });

  it('should create user for testing purposes', async () => {
    const result = await connection.executeQuery(
      "INSERT INTO users (username) VALUES ('test_user') select id from users where username = 'test_user'",
    );
    user_id = result.id;
    expect(result).toBeDefined();
  });

  it('should add user to group', async () => {
    const result = await AccessControlQueries.addUserToGroup(groupID, user_id);
    expect(result.statusCode).toBe(200);
    expect(result.message).toBe('User added to group!');
  });

  it('should return an array of permission groups user is a part of', async () => {
    const result = await AccessControlQueries.getUsersGroups(user_id);
    expect(result.statusCode).toBe(200);
    expect(Array.isArray(result.permissions)).toBe(true);
    expect(result.permissions.length).toBe(1);
  });

  it('should throw an error if you try to add a user to a group that does not exist', async () => {
    await expect(AccessControlQueries.addUserToGroup(user_id, 9999)).rejects.toThrow();
  });

  it('should throw an error if you try to add a non-existent user to a group', async () => {
    await expect(AccessControlQueries.addUserToGroup(9999, groupID)).rejects.toThrow();
  });

  it('should throw an error if the user is already in the group', async () => {
    await expect(AccessControlQueries.addUserToGroup(groupID, user_id)).rejects.toThrow();
  });

  it('should remove user from group', async () => {
    const result = await AccessControlQueries.removeUserFromGroup(groupID, user_id);

    expect(result.statusCode).toBe(200);
    expect(result.message).toBe('User removed from group!');
  });

  it('should throw an error if you try to remove a user from a group hes not a part of', async () => {
    expect(AccessControlQueries.removeUserFromGroup(groupID, user_id)).rejects.toThrow();
  });

  it('should return an empty array if user has no groups', async () => {
    const result = await AccessControlQueries.getUsersGroups(user_id);
    expect(result.statusCode).toBe(200);
    expect(result.permissions).toEqual([]);
  });

  it('should get all groups', async () => {
    const groups = await AccessControlQueries.getGroups();

    expect(groups.statusCode).toBe(200);
    expect(Array.isArray(groups.permission_groups)).toBe(true);
  });

  it('should delete an existing group', async () => {
    const result = await AccessControlQueries.deleteGroup(groupID);

    expect(result.statusCode).toBe(200);
    expect(result.message).toBe('Permission group Deleted!');
  });

  it('should throw an error that the group doesnt exist', async () => {
    await expect(AccessControlQueries.deleteGroup(groupID)).rejects.toThrow();
  });

  it('should delete an existing permission', async () => {
    const result = await AccessControlQueries.deletePermission(permissionId);
    expect(result.statusCode).toBe(200);
    expect(result.message).toBe('Permission Deleted!');
  });

  it('should throw an error that the permission doesnt exist', async () => {
    expect(AccessControlQueries.deletePermission(permissionId)).rejects.toThrow();
  });

  it('should return an empty object if permission does not exist', async () => {
    const result = await AccessControlQueries.getPermission(permissionId);
    expect(result.permissions).toEqual({});
  });

  it('should delete user that was made for testing', async () => {
    await connection.executeQuery('DELETE FROM users WHERE id = @id', [{ name: 'id', type: 'INT', value: user_id }]);
  });

  it('should delete property that was made for testing', async () => {
    await connection.executeQuery('DELETE FROM gr_permission_properties WHERE id = @id', [{ name: 'id', type: 'INT', value: property_id }]);
  });

  it('should close the connection', async () => {
    const consoleSpy = jest.spyOn(console, 'log');
    await connection.close();
    expect(consoleSpy).toHaveBeenCalledWith('🔒 Connection to MSSQL database closed');
    consoleSpy.mockRestore();
  });
});
