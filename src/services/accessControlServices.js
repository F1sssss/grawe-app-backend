const accessControlQueries = require('../sql/Queries/accessControlQueries');
const cacheQuery = require('../utils/cacheQuery');
const { delKey } = require('./cachingService');

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
  await delKey('permission-groups');
  const { permission_group, statusCode } = await accessControlQueries.createGroup(group);
  return { permission_group, statusCode };
};

const updateGroupService = async (id, group) => {
  await delKey('permissions');
  await delKey('permission-groups');
  await delKey(`permission-group-${group}`);
  await delKey(`permission-${id}`);
  const { permission_group, statusCode } = await accessControlQueries.updateGroup(id, group.permission_group);
  return { permission_group, statusCode };
};

const deleteGroupService = async (id) => {
  await delKey('permission-groups');
  const { message, statusCode } = await accessControlQueries.deleteGroup(id);
  return { message, statusCode };
};

const getPermissionsService = async () => {
  const cacheKey = 'permissions';
  const { permissions, statusCode } = await cacheQuery(cacheKey, accessControlQueries.getPermissions());
  return { permissions, statusCode };
};

const getPermissionService = async (id, group) => {
  //const cacheKey = `permission-${id}-${group}`;
  const { permissions, statusCode } = await accessControlQueries.getPermission(id, group);
  return { permissions, statusCode };
};

const createPermissionService = async (permission) => {
  await delKey('permissions');
  const { permissions, statusCode } = await accessControlQueries.createPermission(permission);
  return { permissions, statusCode };
};

const createPermissionPropertiesService = async (id, group) => {
  await delKey('permissions');
  await delKey('permission-groups');
  await delKey(`permission-group-${group}`);
  await delKey(`permission-${id}`);
  const { permissions, statusCode } = await accessControlQueries.createPermissionProperties(id, group);
  return { permissions, statusCode };
};

const updatePermissionService = async (id, permission) => {
  await delKey(`permission-${id}`);
  await delKey('permissions');
  await delKey('permission-groups');
  const { permissions, statusCode } = await accessControlQueries.updatePermission(id, permission);
  return { permissions, statusCode };
};

const updatePermissionRigthsService = async (id, group, read, write) => {
  await delKey('permissions');
  await delKey('permission-groups');
  await delKey(`permission-group-${group}`);
  await delKey(`permission-${id}`);
  await delKey(`permission-${group}-${id}`);
  const { permissions, statusCode } = await accessControlQueries.updatePermissionRigths(id, group, read, write);
  return { permissions, statusCode };
};

const addPermissionToGroupService = async (group, permission) => {
  await delKey('permissions');
  await delKey('permission-groups');
  await delKey(`permission-group-${group}`);
  await delKey(`permission-${permission}`);
  await delKey(`permission-${permission}-${group}`);
  let { permissions, statusCode } = await accessControlQueries.addPermissionToGroup(group, permission);
  await accessControlQueries.createPermissionProperties(permission, group);

  return { permissions, statusCode };
};

const removePermissionFromGroupService = async (id, permission) => {
  await delKey('permissions');
  await delKey('permission-groups');
  await delKey(`permission-group-${id}`);
  await delKey(`permission-${permission}`);
  await delKey(`permission-${permission}-${id}`);
  const { message, statusCode } = await accessControlQueries.removePermissionFromGroup(id, permission);
  return { message, statusCode };
};

const deletePermissionService = async (id) => {
  await delKey('permissions');
  await delKey('permission-groups');
  const { message, statusCode } = await accessControlQueries.deletePermission(id);
  return { message, statusCode };
};

const getUsersGroupsService = async (id) => {
  const cacheKey = `permission-groups-user-${id}`;
  const { permissions, statusCode } = await cacheQuery(cacheKey, accessControlQueries.getUsersGroups(id));
  return { permissions, statusCode };
};

const addUserToGroupService = async (id, user) => {
  await delKey('permissions');
  await delKey('permission-groups');
  await delKey(`permission-groups-user-${user}`);
  const { message, statusCode } = await accessControlQueries.addUserToGroup(id, user);
  return { message, statusCode };
};

const removeUserFromGroupService = async (id, user) => {
  await delKey('permissions');
  await delKey('permission-groups');
  await delKey(`permission-groups-user-${id}`);
  const { message, statusCode } = await accessControlQueries.removeUserFromGroup(id, user);
  return { message, statusCode };
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
  createPermissionPropertiesService,
  removeUserFromGroupService,
  addUserToGroupService,
};
