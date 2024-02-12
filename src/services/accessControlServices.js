const accessControlQueries = require('../sql/Queries/accessControlQueries');
const cacheQuery = require('../utils/cacheQuery');

const getGroupsService = async () => {
  const cacheKey = 'groups';
  const { groups, statusCode } = await cacheQuery(cacheKey, accessControlQueries.getGroups());
  return { groups, statusCode };
};

const getGroupService = async (id) => {
  const cacheKey = `group-${id}`;
  const { group, statusCode } = await cacheQuery(cacheKey, accessControlQueries.getGroup(id));
  return { group, statusCode };
};

const createGroupService = async (group) => {
  const { statusCode } = await accessControlQueries.createGroup(group);
  return { statusCode };
};

const updateGroupService = async (id, group) => {
  const { statusCode } = await accessControlQueries.updateGroup(id, group);
  return { statusCode };
};

const getPermissionsService = async () => {
  const cacheKey = 'permissions';
  const { permissions, statusCode } = await cacheQuery(cacheKey, accessControlQueries.getPermissions());
  return { permissions, statusCode };
};

const getPermissionService = async (id) => {
  const cacheKey = `permission-${id}`;
  const { permission, statusCode } = await cacheQuery(cacheKey, accessControlQueries.getPermission(id));
  return { permission, statusCode };
};

const createPermissionService = async (permission) => {
  const { statusCode } = await accessControlQueries.createPermission(permission);
  return { statusCode };
};

const updatePermissionService = async (id, permission) => {
  const { statusCode } = await accessControlQueries.updatePermission(id, permission);
  return { statusCode };
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
};
