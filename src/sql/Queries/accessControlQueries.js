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

  if (!permissions && queryFileName === 'getclientInfo.sql') {
    throw new AppError('Error during getting permissions!', 404, 'error-getting-permissions-not-found');
  }

  return { data: permissions === undefined ? {} : permissions, statusCode: 200 };
};

const getPermissions = async () => {
  const { data, statusCode } = await excecuteQueryAndHandleErrors('getPermissionsList.sql');
  return { permissions: data, statusCode };
};

const getPermission = async (id, group) => {
  const { data, statusCode } = await excecuteQueryAndHandleErrors('getPermission.sql', PermissionProperties(id, group));
  return { permissions: data, statusCode };
};

const createPermission = async (permission) => {
  const { data, statusCode } = await excecuteQueryAndHandleErrors('createPermission.sql', Permission(permission));
  return { permissions: data, statusCode };
};

const createPermissionProperties = async (id, group) => {
  const { data, statusCode } = await excecuteQueryAndHandleErrors('createPermissionProperties.sql', PermissionProperties(id, group));
  return { permissions: data, statusCode };
};

const getPermissionsByGroup = async (id) => {
  const { data, statusCode } = await excecuteQueryAndHandleErrors('getPermissionsByGroup.sql', PermissionGroupID(id));
  return { permissions: data, statusCode };
};

const deletePermission = async (id) => {
  const data = await excecuteQueryAndHandleErrors('deletePermission.sql', PermissionID(id));

  if (data === {}) {
    throw new AppError('Error deleting permission!', 404, 'error-deleting-permission-not-found');
  }

  return { message: 'Permission Deleted!', statusCode: 200 };
};

const updatePermission = async (id, permission) => {
  const { data, statusCode } = await excecuteQueryAndHandleErrors('updatePermission.sql', PermissionUpdate(id, permission));
  return { permissions: data, statusCode };
};

const updatePermissionRigths = async (id, group, read, write) => {
  const { data, statusCode } = await excecuteQueryAndHandleErrors('updatePermissionRights.sql', PermissionRights(id, group, read, write));
  return { permissions: data, statusCode };
};

const addPermissionToGroup = async (group, permission) => {
  const { data, statusCode } = await excecuteQueryAndHandleErrors('addPermissionToGroup.sql', PermissionGroupPairing(group, permission));
  return { permissions: data, statusCode };
};

const removePermissionFromGroup = async (group, permission) => {
  const data = await excecuteQueryAndHandleErrors('removePermissionFromGroup.sql', PermissionGroupPairing(group, permission));

  if (data === {}) {
    throw new AppError('Error removing permission from group!', 404, 'error-removing-permission-from-group-not-found');
  }

  return { message: 'Permission removed from group!', statusCode: 200 };
};

const getUsersGroups = async (id) => {
  const { data, statusCode } = await excecuteQueryAndHandleErrors('getUserGroups.sql', Client(id));
  return { permissions: data, statusCode };
};

const getGroups = async () => {
  let { data, statusCode } = await excecuteQueryAndHandleErrors('getPermissionGroups.sql');
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
  const { data, statusCode } = await excecuteQueryAndHandleErrors('getPermissionGroup.sql', PermissionGroupID(id));
  return { permission_group: data, statusCode };
};

const createGroup = async (group) => {
  const { data, statusCode } = await excecuteQueryAndHandleErrors('createPermissionGroup.sql', PermissionGroupName(group));
  return { permission_group: data, statusCode };
};

const updateGroup = async (id, group) => {
  const { data, statusCode } = await excecuteQueryAndHandleErrors('updatePermissionGroup.sql', PermissionGroup(id, group));
  return { permission_group: data, statusCode };
};

const deleteGroup = async (id) => {
  const permission_group = await excecuteQueryAndHandleErrors('deletePermissionGroup.sql', PermissionGroupID(id));

  if (permission_group === {}) {
    throw new AppError('Error deleting permission group!', 404, 'error-deleting-permission-group-not-found');
  }

  return { message: 'Permission group Deleted!', statusCode: 200 };
};

const addUserToGroup = async (id, user) => {
  const { data, statusCode } = await excecuteQueryAndHandleErrors('addUserToGroup.sql', ClientGroup(id, user));

  if (data === {}) {
    throw new AppError('Error adding user to group!', 404, 'error-adding-user-to-group-not-found');
  }

  return { message: 'User added to group!', statusCode };
};

const removeUserFromGroup = async (id, user) => {
  const { data, statusCode } = await excecuteQueryAndHandleErrors('removeUserFromGroup.sql', ClientGroup(id, user));

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
