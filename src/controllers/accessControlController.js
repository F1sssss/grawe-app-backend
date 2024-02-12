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
  await ResponseHandler(accessControlService.createGroupService(req.body), res, { statusCode: 201, message: 'Group created successfully!' });
});

const updateGroup = CatchAsync(async (req, res) => {
  await ResponseHandler(accessControlService.updateGroupService(req.params.id, req.body), res, {
    statusCode: 200,
    message: 'Group updated successfully!',
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

module.exports = {
  getGroups,
  getGroup,
  createGroup,
  updateGroup,
  getPermissions,
  getPermission,
  createPermission,
  updatePermission,
};
