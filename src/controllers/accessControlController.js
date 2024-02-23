const accessControlService = require('../services/accessControlServices');
const CatchAsync = require('../utils/CatchAsync');
const ResponseHandler = require('../utils/ResponseHandler');

const getGroups = CatchAsync(async (req, res) => {
  await ResponseHandler(accessControlService.getGroupsService(), res, { statusCode: 200, message: 'Groups retrieved successfully!' });
});

const getGroup = CatchAsync(async (req, res) => {
  await ResponseHandler(accessControlService.getGroupService(req.params.id), res, { statusCode: 200, message: 'Group retrieved successfully!' });
});

const createGroup = CatchAsync(async (req, res) => {
  await ResponseHandler(accessControlService.createGroupService(req.body.permission_group), res, {
    statusCode: 201,
    message: 'Group created successfully!',
  });
});

const updateGroup = CatchAsync(async (req, res) => {
  await ResponseHandler(accessControlService.updateGroupService(req.params.id, req.body), res, {
    statusCode: 200,
    message: 'Group updated successfully!',
  });
});

const deleteGroup = CatchAsync(async (req, res) => {
  await ResponseHandler(accessControlService.deleteGroupService(req.params.id), res, {
    statusCode: 200,
    message: 'Group deleted successfully!',
  });
});

const getPermissions = CatchAsync(async (req, res) => {
  await ResponseHandler(accessControlService.getPermissionsService(), res, { statusCode: 200, message: 'Permissions retrieved successfully!' });
});

const getPermission = CatchAsync(async (req, res) => {
  await ResponseHandler(accessControlService.getPermissionService(req.params.id), res, {
    statusCode: 200,
    message: 'Permission retrieved successfully!',
  });
});

const createPermission = CatchAsync(async (req, res) => {
  await ResponseHandler(accessControlService.createPermissionService(req.body), res, {
    statusCode: 201,
    message: 'Permission created successfully!',
  });
});

const updatePermission = CatchAsync(async (req, res) => {
  await ResponseHandler(accessControlService.updatePermissionService(req.params.id, req.body), res, {
    statusCode: 200,
    message: 'Permission updated successfully!',
  });
});

const updatePermissionRigths = CatchAsync(async (req, res) => {
  await ResponseHandler(accessControlService.updatePermissionRigthsService(req.params.id, req.query.read, req.query.write), res, {
    statusCode: 200,
    message: 'Permission rights updated successfully!',
  });
});

const addPermissionToGroup = CatchAsync(async (req, res) => {
  await ResponseHandler(accessControlService.addPermissionToGroupService(req.query.group, req.query.permission), res, {
    statusCode: 200,
    message: 'Permission added to group successfully!',
  });
});

const removePermissionFromGroup = CatchAsync(async (req, res) => {
  await ResponseHandler(accessControlService.removePermissionFromGroupService(req.query.group, req.query.permission), res, {
    statusCode: 200,
    message: 'Permission removed from group successfully!',
  });
});

const deletePermission = CatchAsync(async (req, res) => {
  await ResponseHandler(accessControlService.deletePermissionService(req.params.id), res, {
    statusCode: 200,
    message: 'Permission deleted successfully!',
  });
});

const getUsersGroups = CatchAsync(async (req, res) => {
  await ResponseHandler(accessControlService.getUsersGroupsService(req.params.id), res, {
    statusCode: 200,
    message: 'User groups retrieved successfully!',
  });
});

module.exports = {
  getGroups,
  getGroup,
  createGroup,
  updateGroup,
  getPermissions,
  getPermission,
  createPermission,
  updatePermission,
  deleteGroup,
  updatePermissionRigths,
  addPermissionToGroup,
  removePermissionFromGroup,
  deletePermission,
  getUsersGroups,
};
