const DBConnection = require('../DBConnection');
const DB_CONFIG = require('../DBconfig');
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

const excecuteQueryAndHandleErrors = async (queryFileName, params) => {
  const connection = new DBConnection(DB_CONFIG.sql);
  const permissions = await connection.executeQuery(queryFileName, params);

  if (!permissions && queryFileName === 'get_client_info.sql') {
    throw new AppError('Error during getting permissions!', 404, 'error-getting-permissions-not-found');
  }

  return { data: permissions === undefined ? {} : permissions, statusCode: 200 };
};

const getPermissions = async () => {
  const { data, statusCode } = await excecuteQueryAndHandleErrors('get_permission_all.sql');
  return { permissions: data, statusCode };
};

const getPermission = async (id, group) => {
  const { data, statusCode } = await excecuteQueryAndHandleErrors('get_permission.sql', PermissionProperties(id, group));
  return { permissions: data, statusCode };
};

const createPermission = async (permission) => {
  const { data, statusCode } = await excecuteQueryAndHandleErrors('add_permission.sql', Permission(permission));
  return { permissions: data, statusCode };
};

const createPermissionProperties = async (id, group) => {
  const { data, statusCode } = await excecuteQueryAndHandleErrors('add_permission_properties.sql', PermissionProperties(id, group));
  return { permissions: data, statusCode };
};

const getPermissionsByGroup = async (id) => {
  const { data, statusCode } = await excecuteQueryAndHandleErrors('get_permission_for_group.sql', PermissionGroupID(id));
  return { permissions: data, statusCode };
};

const deletePermission = async (id) => {
  const data = await excecuteQueryAndHandleErrors('delete_permission.sql', PermissionID(id));

  if (data === {}) {
    throw new AppError('Error deleting permission!', 404, 'error-deleting-permission-not-found');
  }

  return { message: 'Permission Deleted!', statusCode: 200 };
};

const updatePermission = async (id, permission) => {
  const { data, statusCode } = await excecuteQueryAndHandleErrors('update_permission.sql', PermissionUpdate(id, permission));
  return { permissions: data, statusCode };
};

const updatePermissionRigths = async (id, group, read, write) => {
  const { data, statusCode } = await excecuteQueryAndHandleErrors('update_permission_rights.sql', PermissionRights(id, group, read, write));
  return { permissions: data, statusCode };
};

const addPermissionToGroup = async (group, permission) => {
  const { data, statusCode } = await excecuteQueryAndHandleErrors('add_permission_to_group.sql', PermissionGroupPairing(group, permission));
  return { permissions: data, statusCode };
};

const removePermissionFromGroup = async (group, permission) => {
  const data = await excecuteQueryAndHandleErrors('delete_permission_from_group.sql', PermissionGroupPairing(group, permission));

  if (data === {}) {
    throw new AppError('Error removing permission from group!', 404, 'error-removing-permission-from-group-not-found');
  }

  return { message: 'Permission removed from group!', statusCode: 200 };
};

const getUsersGroups = async (id) => {
  const { data, statusCode } = await excecuteQueryAndHandleErrors('get_permission_group_for_user.sql', Client(id));
  return { permissions: data, statusCode };
};

const getGroups = async () => {
  let { data, statusCode } = await excecuteQueryAndHandleErrors('get_permission_groups_all.sql');
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

  return { permission_groups: data, statusCode };
};

const getGroup = async (id) => {
  const { data, statusCode } = await excecuteQueryAndHandleErrors('get_permission_group.sql', PermissionGroupID(id));
  return { permission_group: data, statusCode };
};

const createGroup = async (group) => {
  const { data, statusCode } = await excecuteQueryAndHandleErrors('add_permission_group.sql', PermissionGroupName(group));
  return { permission_group: data, statusCode };
};

const updateGroup = async (id, group) => {
  const { data, statusCode } = await excecuteQueryAndHandleErrors('update_permission_group.sql', PermissionGroup(id, group));
  return { permission_group: data, statusCode };
};

const deleteGroup = async (id) => {
  const permission_group = await excecuteQueryAndHandleErrors('delete_permission_group.sql', PermissionGroupID(id));

  if (permission_group === {}) {
    throw new AppError('Error deleting permission group!', 404, 'error-deleting-permission-group-not-found');
  }

  return { message: 'Permission group Deleted!', statusCode: 200 };
};

const addUserToGroup = async (id, user) => {
  const { data, statusCode } = await excecuteQueryAndHandleErrors('add_user_to_group.sql', ClientGroup(id, user));

  if (data === {}) {
    throw new AppError('Error adding user to group!', 404, 'error-adding-user-to-group-not-found');
  }

  return { message: 'User added to group!', statusCode };
};

const removeUserFromGroup = async (id, user) => {
  const { data, statusCode } = await excecuteQueryAndHandleErrors('delete_permission_user_from_group.sql', ClientGroup(id, user));

  if (data === {}) {
    throw new AppError('Error removing user from group!', 404, 'error-removing-user-from-group-not-found');
  }

  return { message: 'User removed from group!', statusCode };
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
  updatePermissionRigths,
  addPermissionToGroup,
  removePermissionFromGroup,
  deletePermission,
  getUsersGroups,
  createPermissionProperties,
  addUserToGroup,
  removeUserFromGroup,
};
