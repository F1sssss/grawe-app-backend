// accessControlController.test.js

const accessControlController = require('../../controllers/accessControlController');
const accessControlService = require('../../services/accessControlServices');
const ResponseHandler = require('../../utils/responseHandler');

jest.mock('../../services/accessControlServices');
jest.mock('../../utils/responseHandler');

describe('accessControlController', () => {
  beforeEach(() => {
    jest.clearAllMocks();
  });

  describe('getGroups', () => {
    it('should get groups and send response', async () => {
      const req = {};
      const res = {};
      const groups = { id: 1, name: 'Admin' };

      accessControlService.getGroupsService.mockResolvedValue(groups);

      await accessControlController.getGroups(req, res);

      expect(accessControlService.getGroupsService).toHaveBeenCalled();
      expect(ResponseHandler).toHaveBeenCalledWith(expect.any(Promise), res);
    });
  });

  describe('getGroup', () => {
    it('should get a group by id and send response', async () => {
      const req = { params: { id: '1' } };
      const res = {};
      const group = { id: 1, name: 'Admin' };

      accessControlService.getGroupService.mockResolvedValue(group);

      await accessControlController.getGroup(req, res);

      expect(accessControlService.getGroupService).toHaveBeenCalledWith('1');
      expect(ResponseHandler).toHaveBeenCalledWith(expect.any(Promise), res);
    });
  });

  describe('createGroup', () => {
    it('should create a group and send response with status 201', async () => {
      const req = { body: { permission_group: { name: 'New Group' } } };
      const res = {};
      const group = { id: 1, name: 'New Group' };

      accessControlService.createGroupService.mockResolvedValue(group);
      ResponseHandler.mockResolvedValue();

      await accessControlController.createGroup(req, res);

      expect(accessControlService.createGroupService).toHaveBeenCalledWith(req.body.permission_group);
      expect(ResponseHandler).toHaveBeenCalledWith(expect.any(Promise), res, { statusCode: 201 });
    });
  });

  describe('updateGroup', () => {
    it('should update a group and send response with status 200', async () => {
      const req = { params: { id: '1' }, body: { name: 'Updated Group' } };
      const res = {};
      const group = { id: 1, name: 'Updated Group' };

      accessControlService.updateGroupService.mockResolvedValue(group);
      ResponseHandler.mockResolvedValue();

      await accessControlController.updateGroup(req, res);

      expect(accessControlService.updateGroupService).toHaveBeenCalledWith('1', req.body);
      expect(ResponseHandler).toHaveBeenCalledWith(expect.any(Promise), res, { statusCode: 200 });
    });
  });

  describe('deleteGroup', () => {
    it('should delete a group and send response with status 200', async () => {
      const req = { params: { id: '1' } };
      const res = {};
      const result = { message: 'Group deleted' };

      accessControlService.deleteGroupService.mockResolvedValue(result);
      ResponseHandler.mockResolvedValue();

      await accessControlController.deleteGroup(req, res);

      expect(accessControlService.deleteGroupService).toHaveBeenCalledWith('1');
      expect(ResponseHandler).toHaveBeenCalledWith(expect.any(Promise), res, { statusCode: 200 });
    });
  });

  describe('getPermissions', () => {
    it('should get permissions and send response', async () => {
      const req = {};
      const res = {};
      const permissions = [
        { id: 1, name: 'Read' },
        { id: 2, name: 'Write' },
      ];

      accessControlService.getPermissionsService.mockResolvedValue(permissions);
      ResponseHandler.mockResolvedValue();

      await accessControlController.getPermissions(req, res);

      expect(accessControlService.getPermissionsService).toHaveBeenCalled();
      expect(ResponseHandler).toHaveBeenCalledWith(expect.any(Promise), res);
    });
  });

  describe('getPermission', () => {
    it('should get a permission by id and group and send response with status 200', async () => {
      const req = { params: { id: '1' }, query: { group: '2' } };
      const res = {};
      const permission = { id: 1, name: 'Read' };

      accessControlService.getPermissionService.mockResolvedValue(permission);
      ResponseHandler.mockResolvedValue();

      await accessControlController.getPermission(req, res);

      expect(accessControlService.getPermissionService).toHaveBeenCalledWith('1', '2');
      expect(ResponseHandler).toHaveBeenCalledWith(expect.any(Promise), res, { statusCode: 200 });
    });
  });

  describe('createPermission', () => {
    it('should create a permission and send response with status 201', async () => {
      const req = { body: { name: 'New Permission' } };
      const res = {};
      const permission = { id: 1, name: 'New Permission' };

      accessControlService.createPermissionService.mockResolvedValue(permission);
      ResponseHandler.mockResolvedValue();

      await accessControlController.createPermission(req, res);

      expect(accessControlService.createPermissionService).toHaveBeenCalledWith(req.body);
      expect(ResponseHandler).toHaveBeenCalledWith(expect.any(Promise), res, { statusCode: 201 });
    });
  });

  describe('createPermissionProperties', () => {
    it('should create permission properties and send response with status 201', async () => {
      const req = { params: { id: '1' }, body: { permission_group_id: '2' } };
      const res = {};
      const result = { message: 'Permission properties created' };

      accessControlService.createPermissionPropertiesService.mockResolvedValue(result);
      ResponseHandler.mockResolvedValue();

      await accessControlController.createPermissionProperties(req, res);

      expect(accessControlService.createPermissionPropertiesService).toHaveBeenCalledWith('1', '2');
      expect(ResponseHandler).toHaveBeenCalledWith(expect.any(Promise), res, { statusCode: 201 });
    });
  });

  describe('updatePermission', () => {
    it('should update a permission and send response with status 200', async () => {
      const req = { params: { id: '1' }, body: { name: 'Updated Permission' } };
      const res = {};
      const permission = { id: 1, name: 'Updated Permission' };

      accessControlService.updatePermissionService.mockResolvedValue(permission);
      ResponseHandler.mockResolvedValue();

      await accessControlController.updatePermission(req, res);

      expect(accessControlService.updatePermissionService).toHaveBeenCalledWith('1', req.body);
      expect(ResponseHandler).toHaveBeenCalledWith(expect.any(Promise), res, { statusCode: 200 });
    });
  });

  describe('updatePermissionRights', () => {
    it('should update permission rights and send response with status 200', async () => {
      const req = { params: { id: '1' }, query: { group: '2', read: 'true', write: 'false' } };
      const res = {};
      const result = { message: 'Permission rights updated' };

      accessControlService.updatePermissionRightsService.mockResolvedValue(result);
      ResponseHandler.mockResolvedValue();

      await accessControlController.updatePermissionRights(req, res);

      expect(accessControlService.updatePermissionRightsService).toHaveBeenCalledWith('1', '2', 'true', 'false');
      expect(ResponseHandler).toHaveBeenCalledWith(expect.any(Promise), res, { statusCode: 200 });
    });
  });

  describe('addPermissionToGroup', () => {
    it('should add permission to group and send response with status 200', async () => {
      const req = { query: { group: '1', permission: '2' } };
      const res = {};
      const result = { message: 'Permission added to group' };

      accessControlService.addPermissionToGroupService.mockResolvedValue(result);
      ResponseHandler.mockResolvedValue();

      await accessControlController.addPermissionToGroup(req, res);

      expect(accessControlService.addPermissionToGroupService).toHaveBeenCalledWith('1', '2');
      expect(ResponseHandler).toHaveBeenCalledWith(expect.any(Promise), res, { statusCode: 200 });
    });
  });

  describe('removePermissionFromGroup', () => {
    it('should remove permission from group and send response with status 200', async () => {
      const req = { query: { group: '1', permission: '2' } };
      const res = {};
      const result = { message: 'Permission removed from group' };

      accessControlService.removePermissionFromGroupService.mockResolvedValue(result);
      ResponseHandler.mockResolvedValue();

      await accessControlController.removePermissionFromGroup(req, res);

      expect(accessControlService.removePermissionFromGroupService).toHaveBeenCalledWith('1', '2');
      expect(ResponseHandler).toHaveBeenCalledWith(expect.any(Promise), res, { statusCode: 200 });
    });
  });

  describe('deletePermission', () => {
    it('should delete a permission and send response with status 200', async () => {
      const req = { params: { id: '1' } };
      const res = {};
      const result = { message: 'Permission deleted' };

      accessControlService.deletePermissionService.mockResolvedValue(result);
      ResponseHandler.mockResolvedValue();

      await accessControlController.deletePermission(req, res);

      expect(accessControlService.deletePermissionService).toHaveBeenCalledWith('1');
      expect(ResponseHandler).toHaveBeenCalledWith(expect.any(Promise), res, { statusCode: 200 });
    });
  });

  describe('getUsersGroups', () => {
    it('should get user groups and send response with status 200', async () => {
      const req = { params: { id: '1' } };
      const res = {};
      const groups = [{ id: 1, name: 'Admin' }];

      accessControlService.getUsersGroupsService.mockResolvedValue(groups);
      ResponseHandler.mockResolvedValue();

      await accessControlController.getUsersGroups(req, res);

      expect(accessControlService.getUsersGroupsService).toHaveBeenCalledWith('1');
      expect(ResponseHandler).toHaveBeenCalledWith(expect.any(Promise), res, { statusCode: 200 });
    });
  });

  describe('addUserToGroup', () => {
    it('should add user to group and send response with status 200', async () => {
      const req = { params: { id: '1' }, query: { user: '2' } };
      const res = {};
      const result = { message: 'User added to group' };

      accessControlService.addUserToGroupService.mockResolvedValue(result);
      ResponseHandler.mockResolvedValue();

      await accessControlController.addUserToGroup(req, res);

      expect(accessControlService.addUserToGroupService).toHaveBeenCalledWith('1', '2');
      expect(ResponseHandler).toHaveBeenCalledWith(expect.any(Promise), res, { statusCode: 200 });
    });
  });

  describe('removeUserFromGroup', () => {
    it('should remove user from group and send response with status 200', async () => {
      const req = { params: { id: '1' }, query: { user: '2' } };
      const res = {};
      const result = { message: 'User removed from group' };

      accessControlService.removeUserFromGroupService.mockResolvedValue(result);
      ResponseHandler.mockResolvedValue();

      await accessControlController.removeUserFromGroup(req, res);

      expect(accessControlService.removeUserFromGroupService).toHaveBeenCalledWith('1', '2');
      expect(ResponseHandler).toHaveBeenCalledWith(expect.any(Promise), res, { statusCode: 200 });
    });
  });
});
