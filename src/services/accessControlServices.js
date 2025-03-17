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

const updatePermissionRightsService = async (id, group, read, write) => {
  await delKey('permissions');
  await delKey('permission-groups');
  await delKey(`permission-group-${group}`);
  await delKey(`permission-${id}`);
  await delKey(`permission-${group}-${id}`);
  const { permissions, statusCode } = await accessControlQueries.updatePermissionRights(id, group, read, write);
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

const getPropertiesService = async () => {
  const cacheKey = 'properties';
  const { properties, statusCode } = await cacheQuery(cacheKey, accessControlQueries.getProperties());
  return { properties, statusCode };
};

const getPermissionPropertiesService = async (permissionId) => {
  const cacheKey = `permission-properties-${permissionId}`;
  const { properties, statusCode } = await cacheQuery(cacheKey, accessControlQueries.getPermissionProperties(permissionId));
  return { properties, statusCode };
};

const addPropertyService = async (propertyPath) => {
  await delKey('properties');
  const { property, statusCode } = await accessControlQueries.addProperty(propertyPath);
  return { property, statusCode };
};

const addPermissionPropertyService = async (permissionId, propertyId) => {
  await delKey('permissions');
  await delKey('properties');
  await delKey(`permission-properties-${permissionId}`);
  const { property, statusCode } = await accessControlQueries.addPermissionProperty(permissionId, propertyId);
  return { property, statusCode };
};

const deletePermissionPropertyService = async (permissionId, propertyId) => {
  await delKey('permissions');
  await delKey('properties');
  await delKey(`permission-properties-${permissionId}`);
  const { message, statusCode } = await accessControlQueries.deletePermissionProperty(permissionId, propertyId);
  return { message, statusCode };
};

const getUsersGroupsService = async (id) => {
  const cacheKey = `permission-groups-user-${id}`;
  const { permissions, statusCode } = await cacheQuery(cacheKey, accessControlQueries.getUsersGroups(id));
  return { permissions: permissions && permissions.id === null ? {} : permissions, statusCode };
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
  await delKey(`permission-groups-user-${user}`);
  const { message, statusCode } = await accessControlQueries.removeUserFromGroup(id, user);
  return { message, statusCode };
};

const getHierarchyGroupsService = async () => {
  const cacheKey = 'hierarchy-groups';
  const { permission_groups, statusCode } = await cacheQuery(cacheKey, accessControlQueries.getHierarchyGroups());
  return { permission_groups, statusCode };
};

const getHierarchyGroupService = async (id) => {
  const cacheKey = `hierarchy-group-${id}`;
  const { permission_group, statusCode } = await cacheQuery(cacheKey, accessControlQueries.getHierarchyGroup(id));
  return { permission_group, statusCode };
};

const getUserHierarchyGroupsService = async (userId) => {
  const cacheKey = `user-hierarchy-groups-${userId}`;
  const { permission_groups, statusCode } = await cacheQuery(cacheKey, accessControlQueries.getUserHierarchyGroups(userId));
  return { permission_groups, statusCode };
};

const getGroupVKTOsService = async (groupId) => {
  const cacheKey = `group-vktos-${groupId}`;
  const { vktos, statusCode } = await cacheQuery(cacheKey, accessControlQueries.getGroupVKTOs(groupId));
  return { vktos, statusCode };
};

const createHierarchyGroupService = async (group) => {
  await delKey('hierarchy-groups');
  const { permission_group, statusCode } = await accessControlQueries.createHierarchyGroup(group);
  return { permission_group, statusCode };
};

const updateHierarchyGroupService = async (id, group) => {
  await delKey('hierarchy-groups');
  await delKey(`hierarchy-group-${id}`);
  await delKey(`group-vktos-${id}`);
  await delKey(`vkto`);
  const { permission_group, statusCode } = await accessControlQueries.updateHierarchyGroup(id, group);
  return { permission_group, statusCode };
};

const deleteHierarchyGroupService = async (id) => {
  await delKey('hierarchy-groups');
  await delKey(`hierarchy-group-${id}`);
  const { message, statusCode } = await accessControlQueries.deleteHierarchyGroup(id);
  return { message, statusCode };
};

const addUserToHierarchyGroupService = async (groupId, userId) => {
  await delKey('hierarchy-groups');
  await delKey(`user-hierarchy-groups-${userId}`);
  await delKey(`hierarchy-group-users-${groupId}`);
  const { message, statusCode } = await accessControlQueries.addUserToHierarchyGroup(groupId, userId);
  return { message, statusCode };
};

const removeUserFromHierarchyGroupService = async (groupId, userId) => {
  await delKey('hierarchy-groups');
  await delKey(`user-hierarchy-groups-${userId}`);
  await delKey(`hierarchy-group-users-${groupId}`);
  const { message, statusCode } = await accessControlQueries.removeUserFromHierarchyGroup(groupId, userId);
  return { message, statusCode };
};

const getUsersInHierarchyGroupService = async (groupId) => {
  const cacheKey = `hierarchy-group-users-${groupId}`;
  const { users, statusCode } = await cacheQuery(cacheKey, accessControlQueries.getUsersInHierarchyGroup(groupId));
  return { users, statusCode };
};

const addVKTOToHierarchyGroupService = async (groupId, vkto) => {
  await delKey('hierarchy-groups');
  await delKey(`group-vktos-${groupId}`);
  await delKey(`group-vktos-${groupId}`);
  await delKey(`vkto`);
  const { message, statusCode } = await accessControlQueries.addVKTOToHierarchyGroup(groupId, vkto);
  return { message, statusCode };
};

const removeVKTOFromHierarchyGroupService = async (groupId, vkto) => {
  await delKey('hierarchy-groups');
  await delKey(`group-vktos-${groupId}`);
  await delKey(`vkto`);
  const { message, statusCode } = await accessControlQueries.removeVKTOFromHierarchyGroup(groupId, vkto);
  return { message, statusCode };
};

const getAllVKTOsService = async () => {
  const cacheKey = 'vkto';
  const { vktos, statusCode } = await cacheQuery(cacheKey, accessControlQueries.getAllVKTOs());
  return { vktos, statusCode };
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
  updatePermissionRightsService,
  getPropertiesService,
  getPermissionPropertiesService,
  addPropertyService,
  addPermissionPropertyService,
  deletePermissionPropertyService,
  addPermissionToGroupService,
  removePermissionFromGroupService,
  deletePermissionService,
  getUsersGroupsService,
  createPermissionPropertiesService,
  removeUserFromGroupService,
  addUserToGroupService,
  getHierarchyGroupsService,
  getHierarchyGroupService,
  getUserHierarchyGroupsService,
  getGroupVKTOsService,
  createHierarchyGroupService,
  updateHierarchyGroupService,
  deleteHierarchyGroupService,
  addUserToHierarchyGroupService,
  removeUserFromHierarchyGroupService,
  getUsersInHierarchyGroupService,
  addVKTOToHierarchyGroupService,
  removeVKTOFromHierarchyGroupService,
  getAllVKTOsService,
};
