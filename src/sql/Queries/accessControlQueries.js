const { executeQueryAndHandleErrors, returnArray } = require('../executeQuery');
const AppError = require('../../utils/AppError');
const {
  PermissionGroupID,
  PermissionGroupName,
  PermissionGroup,
  PermissionID,
  Permission,
  PermissionUpdate,
  PermissionRights,
  PermissionGroupPairing,
  Client,
  PermissionProperties,
  ClientGroup,
  HierarchyGroup,
  HierarchyGroupWithID,
  HierarchyGroupID,
  HierarchyGroupUser,
  HierarchyGroupVKTO,
  UserID,
  PropertyPath,
  PermissionProperty,
} = require('./params');

const getPermissions = async () => {
  const { data } = await executeQueryAndHandleErrors('get_permission_all.sql');
  return { permissions: data, statusCode: 200 };
};

const getPermission = async (id, group) => {
  const { data } = await executeQueryAndHandleErrors('get_permission.sql', PermissionProperties(id, group));
  return { permissions: data, statusCode: 200 };
};

const createPermission = async (permission) => {
  const { data } = await executeQueryAndHandleErrors('add_permission.sql', Permission(permission));
  return { permissions: data, statusCode: 201 };
};

const createPermissionProperties = async (id, group) => {
  const { data } = await executeQueryAndHandleErrors('add_permission_properties.sql', PermissionProperties(id, group));
  return { permissions: data, statusCode: 201 };
};

const deletePermission = async (id) => {
  await executeQueryAndHandleErrors('delete_permission.sql', PermissionID(id));
  return { message: 'Permission Deleted!', statusCode: 200 };
};

const updatePermission = async (id, permission) => {
  const { data } = await executeQueryAndHandleErrors('update_permission.sql', PermissionUpdate(id, permission));
  return { permissions: data, statusCode: 200 };
};

const updatePermissionRights = async (id, group, read, write) => {
  const { data } = await executeQueryAndHandleErrors('update_permission_rights.sql', PermissionRights(id, group, read, write));
  return { permissions: data, statusCode: 200 };
};

const addPermissionToGroup = async (group, permission) => {
  const { data } = await executeQueryAndHandleErrors('add_permission_to_group.sql', PermissionGroupPairing(group, permission));
  return { permissions: data, statusCode: 200 };
};

const removePermissionFromGroup = async (group, permission) => {
  await executeQueryAndHandleErrors('delete_permission_from_group.sql', PermissionGroupPairing(group, permission));
  return { message: 'Permission removed from group!', statusCode: 200 };
};

const getUsersGroups = async (id) => {
  const { data } = await executeQueryAndHandleErrors('get_permission_group_for_user.sql', Client(id));
  return { permissions: returnArray(data), statusCode: 200 };
};

const getGroups = async () => {
  let { data } = await executeQueryAndHandleErrors('get_permission_groups_all.sql');
  if (!Array.isArray(data)) {
    return { permission_groups: data ? [data] : [], statusCode: 200 };
  }
  data = await Promise.all(
    data.map(async (group) => {
      const { permissions } = await getPermissionsByGroup(group.id);
      group.permissions = Array.isArray(permissions) ? permissions : Object.keys(permissions).length > 0 ? [permissions] : [];
      return group;
    }),
  );

  return { permission_groups: data, statusCode: 200 };
};

const getPermissionsByGroup = async (id) => {
  const { data, statusCode } = await executeQueryAndHandleErrors('get_permission_group.sql', PermissionGroupID(id));
  return { permissions: data, statusCode };
};

const getGroup = async (id) => {
  const { data } = await executeQueryAndHandleErrors('get_permission_group.sql', PermissionGroupID(id));
  return { permission_group: data, statusCode: 200 };
};

const createGroup = async (group) => {
  const { data } = await executeQueryAndHandleErrors('add_permission_group.sql', PermissionGroupName(group));
  return { permission_group: data, statusCode: 201 };
};

const getProperties = async () => {
  const { data } = await executeQueryAndHandleErrors('get_properties.sql');
  return { properties: returnArray(data), statusCode: 200 };
};

const getPermissionProperties = async (permissionId) => {
  const { data } = await executeQueryAndHandleErrors('get_permission_properties.sql', PermissionID(permissionId));
  return { properties: returnArray(data), statusCode: 200 };
};

const addProperty = async (propertyPath) => {
  const { data } = await executeQueryAndHandleErrors('add_permission_property.sql', PropertyPath(propertyPath));
  return { property: data, statusCode: 201 };
};

const addPermissionProperty = async (permissionId, propertyId) => {
  const { data } = await executeQueryAndHandleErrors('add_permission_property.sql', PermissionProperty(permissionId, propertyId));
  return { property: data, statusCode: 201 };
};

const deletePermissionProperty = async (permissionId, propertyId) => {
  await executeQueryAndHandleErrors('delete_permission_property.sql', PermissionProperty(permissionId, propertyId));
  return { message: 'Permission property deleted!', statusCode: 200 };
};

const updateGroup = async (id, group) => {
  const { data } = await executeQueryAndHandleErrors('update_permission_group.sql', PermissionGroup(id, group));
  return { permission_group: data, statusCode: 200 };
};

const deleteGroup = async (id) => {
  const permission_group = await executeQueryAndHandleErrors('delete_permission_group.sql', PermissionGroupID(id));

  if (permission_group === {}) {
    throw new AppError('Error deleting permission group!', 404, 'error-deleting-permission-group-not-found');
  }

  return { message: 'Permission group Deleted!', statusCode: 200 };
};

const addUserToGroup = async (id, user) => {
  const { data } = await executeQueryAndHandleErrors('add_user_to_group.sql', ClientGroup(id, user));

  if (data === {}) {
    throw new AppError('Error adding user to group!', 404, 'error-adding-user-to-group-not-found');
  }

  return { message: 'User added to group!', statusCode: 200 };
};

const removeUserFromGroup = async (id, user) => {
  const { data } = await executeQueryAndHandleErrors('delete_permission_user_from_group.sql', ClientGroup(id, user));

  if (data === {}) {
    throw new AppError('Error removing user from group!', 404, 'error-removing-user-from-group-not-found');
  }

  return { message: 'User removed from group!', statusCode: 200 };
};

const createHierarchyGroup = async (group) => {
  const { data } = await executeQueryAndHandleErrors('add_hierarchy_group.sql', HierarchyGroup(group.name, group.levelType, group.parentId));

  if (data === {}) {
    throw new AppError('Error creating hierarchy group!', 400, 'error-creating-hierarchy-group');
  }

  return { permission_group: data || {}, statusCode: 201 };
};

const updateHierarchyGroup = async (id, group) => {
  const { data } = await executeQueryAndHandleErrors(
    'update_hierarchy_group.sql',
    HierarchyGroupWithID(id, group.name, group.levelType, group.parentId),
  );

  if (data === {}) {
    throw new AppError('Error updating hierarchy group!', 404, 'error-updating-hierarchy-group-not-found');
  }

  return { permission_group: data || {}, statusCode: 200 };
};

const deleteHierarchyGroup = async (id) => {
  const permission_group = await executeQueryAndHandleErrors('delete_hierarchy_group.sql', HierarchyGroupID(id));

  if (permission_group === {}) {
    throw new AppError('Error deleting hierarchy group!', 404, 'error-deleting-hierarchy-group-not-found');
  }

  return { message: 'Hierarchy group deleted!', statusCode: 200 };
};

const addUserToHierarchyGroup = async (groupId, userId) => {
  const { data } = await executeQueryAndHandleErrors('add_user_to_hierarchy_group.sql', HierarchyGroupUser(groupId, userId));

  if (data === {}) {
    throw new AppError('Error adding user to hierarchy group!', 404, 'error-adding-user-to-hierarchy-group-not-found');
  }

  return { message: 'User added to hierarchy group!', statusCode: 200 };
};

const removeUserFromHierarchyGroup = async (groupId, userId) => {
  const { data } = await executeQueryAndHandleErrors('remove_user_from_hierarchy_group.sql', HierarchyGroupUser(groupId, userId));

  if (data === {}) {
    throw new AppError('Error removing user from hierarchy group!', 404, 'error-removing-user-from-hierarchy-group-not-found');
  }

  return { message: 'User removed from hierarchy group!', statusCode: 200 };
};

const getHierarchyGroup = async (id) => {
  const { data } = await executeQueryAndHandleErrors('get_hierarchy_group.sql', HierarchyGroupID(id));
  return { permission_group: data || {}, statusCode: 200 };
};

const getUserHierarchyGroups = async (id) => {
  const { data } = await executeQueryAndHandleErrors('get_user_hierarchy_groups.sql', UserID(id));
  return { permission_groups: returnArray(data), statusCode: 200 };
};

const getUserVKTOGroups = async (id) => {
  const { data } = await executeQueryAndHandleErrors('get_user_vkto_groups.sql', Client(id));
  return { vktos: returnArray(data), statusCode: 200 };
};

const getGroupVKTOs = async (id) => {
  const { data } = await executeQueryAndHandleErrors('get_group_vkto_groups.sql', HierarchyGroupID(id));
  return { vktos: returnArray(data), statusCode: 200 };
};

const getHierarchyGroups = async () => {
  const { data } = await executeQueryAndHandleErrors('get_hierarchy_groups.sql');
  return { permission_groups: returnArray(data), statusCode: 200 };
};

const getUsersInHierarchyGroup = async (groupId) => {
  const { data } = await executeQueryAndHandleErrors('get_users_in_hierarchy_group.sql', HierarchyGroupID(groupId));
  return { users: returnArray(data), statusCode: 200 };
};

const addVKTOToHierarchyGroup = async (groupId, vkto) => {
  await executeQueryAndHandleErrors('add_vkto_to_hierarchy_group.sql', HierarchyGroupVKTO(groupId, vkto));
  return { message: 'VKTO added to hierarchy group!', statusCode: 200 };
};

const removeVKTOFromHierarchyGroup = async (groupId, vkto) => {
  await executeQueryAndHandleErrors('remove_vkto_from_hierarchy_group.sql', HierarchyGroupVKTO(groupId, vkto));
  return { message: 'VKTO removed from hierarchy group!', statusCode: 200 };
};

const getAllVKTOs = async () => {
  const { data } = await executeQueryAndHandleErrors('get_vkto_all.sql');
  return { vktos: returnArray(data), statusCode: 200 };
};

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
  updatePermissionRights,
  addPermissionToGroup,
  removePermissionFromGroup,
  deletePermission,
  getUsersGroups,
  createPermissionProperties,
  addUserToGroup,
  getProperties,
  getPermissionProperties,
  addProperty,
  addPermissionProperty,
  deletePermissionProperty,
  removeUserFromGroup,
  createHierarchyGroup,
  updateHierarchyGroup,
  deleteHierarchyGroup,
  addUserToHierarchyGroup,
  removeUserFromHierarchyGroup,
  getHierarchyGroup,
  getUserHierarchyGroups,
  getUserVKTOGroups,
  getGroupVKTOs,
  getUsersInHierarchyGroup,
  addVKTOToHierarchyGroup,
  removeVKTOFromHierarchyGroup,
  getHierarchyGroups,
  getAllVKTOs,
};
