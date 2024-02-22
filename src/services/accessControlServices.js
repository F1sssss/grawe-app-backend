const accessControlQueries = require('../sql/Queries/accessControlQueries');
const cacheQuery = require('../utils/cacheQuery');

const getGroupsService = async () => {
  const cacheKey = 'permission-groups';
  const { permission_groups, statusCode } = await cacheQuery(cacheKey, accessControlQueries.getGroups());
  return { permission_groups, statusCode };
};

const getGroupService = async (id) => {
  const cacheKey = `permission-group-${id}`;
  const { permission_group, statusCode } = await cacheQuery(cacheKey, accessControlQueries.getGroup(id));
  return { permission_group, statusCode };
};

const createGroupService = async (group) => {
  const { permission_group, statusCode } = await accessControlQueries.createGroup(group);
  return { permission_group, statusCode };
};

const updateGroupService = async (id, group) => {
  const { permission_group, statusCode } = await accessControlQueries.updateGroup(id, group.permission_group);
  return { permission_group, statusCode };
};

const deleteGroupService = async (id) => {
  const { message, statusCode } = await accessControlQueries.deleteGroup(id);
  return { message, statusCode };
};

const getPermissionsService = async () => {
  const cacheKey = 'permissions';
  const { permissions, statusCode } = await cacheQuery(cacheKey, accessControlQueries.getPermissions());
  return { permissions, statusCode };
};

const getPermissionService = async (id) => {
  const cacheKey = `permission-${id}`;
  const { permissions, statusCode } = await cacheQuery(cacheKey, accessControlQueries.getPermission(id));
  return { permissions, statusCode };
};

const createPermissionService = async (permission) => {
  const { permissions, statusCode } = await accessControlQueries.createPermission(permission);
  return { permissions, statusCode };
};

const updatePermissionService = async (id, permission) => {
  const { permissions, statusCode } = await accessControlQueries.updatePermission(id, permission);
  return { permissions, statusCode };
};

const updatePermissionRigthsService = async (id, read, write) => {
  const { permissions, statusCode } = await accessControlQueries.updatePermissionRigths(id, read, write);
  return { permissions, statusCode };
};

const addPermissionToGroupService = async (group, permission) => {
  const { permissions, statusCode } = await accessControlQueries.addPermissionToGroup(group, permission);
  return { permissions, statusCode };
};

const removePermissionFromGroupService = async (id, permission) => {
  const { message, statusCode } = await accessControlQueries.removePermissionFromGroup(id, permission);
  return { message, statusCode };
};

const deletePermissionService = async (id) => {
  const { message, statusCode } = await accessControlQueries.deletePermission(id);
  return { message, statusCode };
};

const getUsersGroupsService = async (id) => {
  const { permissions, statusCode } = await accessControlQueries.getUsersGroups(id);
  return { permissions, statusCode };
};

module.exports = {
  getGroupsService,
  getGroupService,
  createGroupService,
  updateGroupService,
  getPermissionsService,
  getPermissionService,
  createPermissionService,
  updatePermissionService,
  deleteGroupService,
  updatePermissionRigthsService,
  addPermissionToGroupService,
  removePermissionFromGroupService,
  deletePermissionService,
  getUsersGroupsService,
};
