const accessControlQueries = require('../../src/sql/Queries/accessControlQueries');
const cacheQuery = require('../../src/utils/cacheQuery');
const { delKey } = require('../../src/services/cachingService');
const accessControlServices = require('../../src/services/accessControlServices');

jest.mock('../../src/utils/cacheQuery');
jest.mock('../../src/services/cachingService');
jest.mock('../../src/sql/Queries/accessControlQueries');

describe('Access control Services', () => {
  afterEach(() => {
    jest.clearAllMocks(); // Ensure no mocks leak between tests
  });

  describe('getGroupsService', () => {
    it('should return permission groups and status code', async () => {
      const mockResponse = {
        permission_groups: [{ id: 1, name: 'Admin' }],
        statusCode: 200,
      };

      accessControlQueries.getGroups.mockResolvedValue(Promise.resolve(mockResponse));

      cacheQuery.mockResolvedValue(mockResponse);

      const result = await accessControlServices.getGroupsService();

      expect(cacheQuery).toHaveBeenCalledWith('permission-groups', expect.any(Promise));
      expect(result).toEqual(mockResponse);
    });
  });

  describe('getGroupService', () => {
    it('should return permission group by ID and status code', async () => {
      const mockResponse = {
        permission_group: { id: 1, name: 'Admin' },
        statusCode: 200,
      };

      accessControlQueries.getGroup.mockResolvedValue(Promise.resolve(mockResponse));

      cacheQuery.mockResolvedValue(mockResponse);

      const result = await accessControlServices.getGroupService(1);

      expect(cacheQuery).toHaveBeenCalledWith('permission-group-1', expect.any(Promise));
      expect(result).toEqual(mockResponse);
    });
  });

  describe('createGroupService', () => {
    it('should delete permission-groups cache and create a new group', async () => {
      const mockResponse = {
        permission_group: { id: 1, name: 'Admin' },
        statusCode: 201,
      };
      accessControlQueries.createGroup.mockResolvedValue(Promise.resolve(mockResponse));

      const result = await accessControlServices.createGroupService({ name: 'Admin' });

      expect(delKey).toHaveBeenCalledWith('permission-groups');
      expect(accessControlQueries.createGroup).toHaveBeenCalledWith({ name: 'Admin' });
      expect(result).toEqual(mockResponse);
    });
  });

  describe('updateGroupService', () => {
    it('should delete relevant caches and update the group', async () => {
      const mockResponse = {
        permission_group: { id: 1, name: 'Admin' },
        statusCode: 200,
      };
      accessControlQueries.updateGroup.mockResolvedValue(Promise.resolve(mockResponse));

      const result = await accessControlServices.updateGroupService(1, { permission_group: { id: 1, name: 'Super Admin' } });

      expect(delKey).toHaveBeenCalledTimes(4);
      expect(accessControlQueries.updateGroup).toHaveBeenCalledWith(1, { id: 1, name: 'Super Admin' });
      expect(result).toEqual(mockResponse);
    });
  });

  describe('createGroupService', () => {
    it('should delete "permission-groups" cache and create a new group', async () => {
      const mockResponse = { permission_group: { id: 1, name: 'Test Group' }, statusCode: 201 };

      delKey.mockResolvedValue(true);
      accessControlQueries.createGroup.mockResolvedValue(Promise.resolve(mockResponse));

      const result = await accessControlServices.createGroupService('Test Group');

      expect(delKey).toHaveBeenCalledWith('permission-groups');
      expect(accessControlQueries.createGroup).toHaveBeenCalledWith('Test Group');
      expect(result).toEqual(mockResponse);
    });
  });

  describe('updateGroupService', () => {
    it('should delete relevant caches and update the group', async () => {
      const mockResponse = { permission_group: { id: 1, name: 'Updated Group' }, statusCode: 200 };

      delKey.mockResolvedValue(true);
      accessControlQueries.updateGroup.mockResolvedValue(Promise.resolve(mockResponse));

      const group = { permission_group: 'Updated Group' };

      const result = await accessControlServices.updateGroupService(1, group);

      expect(delKey).toHaveBeenCalledTimes(4);
      expect(accessControlQueries.updateGroup).toHaveBeenCalledWith(1, 'Updated Group');
      expect(result).toEqual(mockResponse);
    });
  });

  describe('updatePermissionRightsService', () => {
    it('should delete all related keys and call updatePermissionRights', async () => {
      const id = '123';
      const group = 'admin';
      const read = true;
      const write = false;

      const mockPermissions = { id: '123', group: 'admin', read: true, write: false };
      const mockStatusCode = 200;

      accessControlQueries.updatePermissionRights.mockResolvedValue({ permissions: mockPermissions, statusCode: mockStatusCode });

      const result = await accessControlServices.updatePermissionRightsService(id, group, read, write);

      // Check if all delKey calls were made with correct arguments
      expect(delKey).toHaveBeenCalledTimes(5);
      expect(delKey).toHaveBeenCalledWith('permissions');
      expect(delKey).toHaveBeenCalledWith('permission-groups');
      expect(delKey).toHaveBeenCalledWith(`permission-group-${group}`);
      expect(delKey).toHaveBeenCalledWith(`permission-${id}`);
      expect(delKey).toHaveBeenCalledWith(`permission-${group}-${id}`);

      // Check if updatePermissionRights was called with correct arguments
      expect(accessControlQueries.updatePermissionRights).toHaveBeenCalledWith(id, group, read, write);

      // Check if the function returns the expected result
      expect(result).toEqual({ permissions: mockPermissions, statusCode: mockStatusCode });
    });

    it('should handle errors from updatePermissionRights', async () => {
      const id = '456';
      const group = 'user';
      const read = false;
      const write = true;

      const mockError = new Error('Update failed');
      accessControlQueries.updatePermissionRights.mockRejectedValue(mockError);

      await expect(accessControlServices.updatePermissionRightsService(id, group, read, write)).rejects.toThrow('Update failed');

      // Check if all delKey calls were still made
      expect(delKey).toHaveBeenCalledTimes(5);
    });

    it('should handle errors from delKey', async () => {
      const id = '789';
      const group = 'guest';
      const read = true;
      const write = true;

      const mockError = new Error('Redis error');
      delKey.mockRejectedValue(mockError);

      await expect(accessControlServices.updatePermissionRightsService(id, group, read, write)).rejects.toThrow('Redis error');

      // Check if updatePermissionRights was not called
      expect(accessControlQueries.updatePermissionRights).not.toHaveBeenCalled();
    });
  });

  describe('deleteGroupService', () => {
    it('should delete "permission-groups" cache and delete the group', async () => {
      const mockResponse = { message: 'Group deleted', statusCode: 200 };

      delKey.mockResolvedValue(true);
      accessControlQueries.deleteGroup.mockResolvedValue(Promise.resolve(mockResponse));

      const result = await accessControlServices.deleteGroupService(1);

      expect(delKey).toHaveBeenCalledWith('permission-groups');
      expect(accessControlQueries.deleteGroup).toHaveBeenCalledWith(1);
      expect(result).toEqual(mockResponse);
    });
  });

  describe('getPermissionsService', () => {
    it('should get all permissions and cache the result', async () => {
      const mockResponse = { permissions: [{ id: 1, name: 'Test Permission' }], statusCode: 200 };

      accessControlQueries.getPermissions.mockResolvedValue(Promise.resolve(mockResponse));

      cacheQuery.mockResolvedValue(mockResponse);

      const result = await accessControlServices.getPermissionsService();

      expect(cacheQuery).toHaveBeenCalledWith('permissions', expect.any(Promise));
      expect(result).toEqual(mockResponse);
    });
  });

  describe('getPermissionService', () => {
    it('should get permission by id and group', async () => {
      const mockResponse = { permissions: { id: 1, name: 'Test Permission' }, statusCode: 200 };

      accessControlQueries.getPermission.mockResolvedValue(Promise.resolve(mockResponse));

      const result = await accessControlServices.getPermissionService(1, 'Test Group');

      expect(accessControlQueries.getPermission).toHaveBeenCalledWith(1, 'Test Group');
      expect(result).toEqual(mockResponse);
    });
  });

  describe('createPermissionService', () => {
    it('should delete "permissions" cache and create a new permission', async () => {
      const mockResponse = { permissions: { id: 1, name: 'New Permission' }, statusCode: 201 };

      delKey.mockResolvedValue(true);
      accessControlQueries.createPermission.mockResolvedValue(Promise.resolve(mockResponse));

      const result = await accessControlServices.createPermissionService({ name: 'New Permission' });

      expect(delKey).toHaveBeenCalledWith('permissions');
      expect(accessControlQueries.createPermission).toHaveBeenCalledWith({ name: 'New Permission' });
      expect(result).toEqual(mockResponse);
    });
  });

  describe('createPermissionPropertiesService', () => {
    it('should delete relevant caches and create permission properties', async () => {
      const mockResponse = { permissions: { id: 1, name: 'Property Permission' }, statusCode: 201 };

      delKey.mockResolvedValue(true);
      accessControlQueries.createPermissionProperties.mockResolvedValue(Promise.resolve(mockResponse));

      const result = await accessControlServices.createPermissionPropertiesService(1, 'Test Group');

      expect(delKey).toHaveBeenCalledTimes(4);
      expect(delKey).toHaveBeenCalledWith('permissions');
      expect(delKey).toHaveBeenCalledWith('permission-groups');
      expect(delKey).toHaveBeenCalledWith('permission-group-Test Group');
      expect(delKey).toHaveBeenCalledWith('permission-1');
      expect(accessControlQueries.createPermissionProperties).toHaveBeenCalledWith(1, 'Test Group');
      expect(result).toEqual(mockResponse);
    });
  });

  describe('updatePermissionService', () => {
    it('should delete relevant caches and update a permission', async () => {
      const mockResponse = { permissions: { id: 1, name: 'Updated Permission' }, statusCode: 200 };

      delKey.mockResolvedValue(true);
      accessControlQueries.updatePermission.mockResolvedValue(Promise.resolve(mockResponse));

      const result = await accessControlServices.updatePermissionService(1, { name: 'Updated Permission' });

      expect(delKey).toHaveBeenCalledTimes(3);
      expect(delKey).toHaveBeenCalledWith('permission-1');
      expect(delKey).toHaveBeenCalledWith('permissions');
      expect(delKey).toHaveBeenCalledWith('permission-groups');
      expect(accessControlQueries.updatePermission).toHaveBeenCalledWith(1, { name: 'Updated Permission' });
      expect(result).toEqual(mockResponse);
    });
  });

  describe('addPermissionToGroupService', () => {
    it('should add a permission to a group and create permission properties', async () => {
      const mockResponse = { permissions: { id: 1, name: 'Group Permission' }, statusCode: 200 };

      delKey.mockResolvedValue(true);
      accessControlQueries.addPermissionToGroup.mockResolvedValue(Promise.resolve(mockResponse));
      accessControlQueries.createPermissionProperties.mockResolvedValue(Promise.resolve(mockResponse));

      const result = await accessControlServices.addPermissionToGroupService('Test Group', 1);

      expect(delKey).toHaveBeenCalledTimes(5);
      expect(accessControlQueries.addPermissionToGroup).toHaveBeenCalledWith('Test Group', 1);
      expect(accessControlQueries.createPermissionProperties).toHaveBeenCalledWith(1, 'Test Group');
      expect(result).toEqual(mockResponse);
    });
  });

  describe('removePermissionFromGroupService', () => {
    it('should remove permission from a group and delete relevant caches', async () => {
      const mockResponse = { message: 'Permission removed from group!', statusCode: 200 };

      delKey.mockResolvedValue(true);
      accessControlQueries.removePermissionFromGroup.mockResolvedValue(Promise.resolve(mockResponse));

      const result = await accessControlServices.removePermissionFromGroupService(1, 'Test Permission');

      expect(delKey).toHaveBeenCalledTimes(5);
      expect(accessControlQueries.removePermissionFromGroup).toHaveBeenCalledWith(1, 'Test Permission');
      expect(result).toEqual(mockResponse);
    });
  });

  describe('deletePermissionService', () => {
    it('should delete a permission and clear the caches', async () => {
      const mockResponse = { message: 'Permission deleted', statusCode: 200 };

      delKey.mockResolvedValue(true);
      accessControlQueries.deletePermission.mockResolvedValue(Promise.resolve(mockResponse));

      const result = await accessControlServices.deletePermissionService(1);

      expect(delKey).toHaveBeenCalledTimes(2);
      expect(delKey).toHaveBeenCalledWith('permissions');
      expect(delKey).toHaveBeenCalledWith('permission-groups');
      expect(accessControlQueries.deletePermission).toHaveBeenCalledWith(1);
      expect(result).toEqual(mockResponse);
    });
  });

  describe('getUsersGroupsService', () => {
    it('should get user groups and cache the result', async () => {
      const mockResponse = { permissions: { id: 1, name: 'User Group' }, statusCode: 200 };

      // Mock the database query to return a resolved promise
      accessControlQueries.getUsersGroups.mockResolvedValue(Promise.resolve(Promise.resolve(mockResponse)));

      // Mock cacheQuery to return the same response
      cacheQuery.mockResolvedValue(mockResponse);

      const result = await accessControlServices.getUsersGroupsService(1);

      expect(cacheQuery).toHaveBeenCalledWith('permission-groups-user-1', expect.any(Promise));
      expect(result).toEqual(mockResponse);
    });
  });

  describe('addUserToGroupService', () => {
    it('should add a user to a group and delete relevant caches', async () => {
      const mockResponse = { message: 'User added to group', statusCode: 200 };

      delKey.mockResolvedValue(true);
      accessControlQueries.addUserToGroup.mockResolvedValue(Promise.resolve(mockResponse));

      const result = await accessControlServices.addUserToGroupService(1, 'Test User');

      expect(delKey).toHaveBeenCalledTimes(3);
      expect(accessControlQueries.addUserToGroup).toHaveBeenCalledWith(1, 'Test User');
      expect(result).toEqual(mockResponse);
    });
  });

  describe('removeUserFromGroupService', () => {
    it('should remove a user from a group and delete relevant caches', async () => {
      const mockResponse = { message: 'User removed from group', statusCode: 200 };

      delKey.mockResolvedValue(true);
      accessControlQueries.removeUserFromGroup.mockResolvedValue(Promise.resolve(mockResponse));

      const result = await accessControlServices.removeUserFromGroupService(1, 'Test User');

      expect(delKey).toHaveBeenCalledTimes(3);
      expect(accessControlQueries.removeUserFromGroup).toHaveBeenCalledWith(1, 'Test User');
      expect(result).toEqual(mockResponse);
    });
  });
});
