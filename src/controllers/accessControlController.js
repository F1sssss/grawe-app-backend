const accessControlService = require('../services/accessControlServices');
const CatchAsync = require('../middlewares/CatchAsync');
const ResponseHandler = require('../utils/ResponseHandler');

const getGroups = CatchAsync(async (req, res) => {
  await ResponseHandler(accessControlService.getGroupsService(), res, { statusCode: 200 });
});

const getGroup = CatchAsync(async (req, res) => {
  await ResponseHandler(accessControlService.getGroupService(req.params.id), res, { statusCode: 200 });
});

const createGroup = CatchAsync(async (req, res) => {
  await ResponseHandler(accessControlService.createGroupService(req.body.permission_group), res, {
    statusCode: 201,
  });
});

const updateGroup = CatchAsync(async (req, res) => {
  await ResponseHandler(accessControlService.updateGroupService(req.params.id, req.body), res, {
    statusCode: 200,
  });
});

const deleteGroup = CatchAsync(async (req, res) => {
  await ResponseHandler(accessControlService.deleteGroupService(req.params.id), res, {
    statusCode: 200,
  });
});

const getPermissions = CatchAsync(async (req, res) => {
  await ResponseHandler(accessControlService.getPermissionsService(), res, { statusCode: 200 });
});

const getPermission = CatchAsync(async (req, res) => {
  await ResponseHandler(accessControlService.getPermissionService(req.params.id, req.query.group), res, {
    statusCode: 200,
  });
});

const createPermission = CatchAsync(async (req, res) => {
  await ResponseHandler(accessControlService.createPermissionService(req.body), res, {
    statusCode: 201,
  });
});

const createPermissionProperties = CatchAsync(async (req, res) => {
  await ResponseHandler(accessControlService.createPermissionPropertiesService(req.params.id, req.body.permission_group_id), res, {
    statusCode: 201,
  });
});

const updatePermission = CatchAsync(async (req, res) => {
  await ResponseHandler(accessControlService.updatePermissionService(req.params.id, req.body), res, {
    statusCode: 200,
  });
});

const updatePermissionRigths = CatchAsync(async (req, res) => {
  await ResponseHandler(accessControlService.updatePermissionRigthsService(req.params.id, req.query.group, req.query.read, req.query.write), res, {
    statusCode: 200,
  });
});

const addPermissionToGroup = CatchAsync(async (req, res) => {
  await ResponseHandler(accessControlService.addPermissionToGroupService(req.query.group, req.query.permission), res, {
    statusCode: 200,
  });
});

const removePermissionFromGroup = CatchAsync(async (req, res) => {
  await ResponseHandler(accessControlService.removePermissionFromGroupService(req.query.group, req.query.permission), res, {
    statusCode: 200,
  });
});

const deletePermission = CatchAsync(async (req, res) => {
  await ResponseHandler(accessControlService.deletePermissionService(req.params.id), res, {
    statusCode: 200,
  });
});

const getUsersGroups = CatchAsync(async (req, res) => {
  await ResponseHandler(accessControlService.getUsersGroupsService(req.params.id), res, {
    statusCode: 200,
  });
});

const addUserToGroup = CatchAsync(async (req, res) => {
  await ResponseHandler(accessControlService.addUserToGroupService(req.params.id, req.query.user), res, {
    statusCode: 200,
  });
});

const removeUserFromGroup = CatchAsync(async (req, res) => {
  await ResponseHandler(accessControlService.removeUserFromGroupService(req.params.id, req.query.user), res, {
    statusCode: 200,
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
  createPermissionProperties,
  addUserToGroup,
  removeUserFromGroup,
};
