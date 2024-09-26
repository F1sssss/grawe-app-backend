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
  removeUserFromGroup,
};
