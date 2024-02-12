const DBConnection = require('../DBConnection');
const DB_CONFIG = require('../DBconfig');
const AppError = require('../../utils/AppError');
const RouteObject = require('../../utils/RoutesObject');

const excecuteQueryAndHandleErrors = async (queryFileName, params) => {
  const connection = new DBConnection(DB_CONFIG.sql);
  const permissions = await connection.executeQuery(queryFileName, params);

  if (!permissions && queryFileName === 'getclientInfo.sql') {
    throw new AppError('Error during getting permissions!', 404, 'error-getting-permissions-not-found');
  }

  return { client: permissions === undefined ? {} : permissions, statusCode: 200 };
};

const getPermissions = async () => {
  // const { client, statusCode } = await excecuteQueryAndHandleErrors('getPermissions.sql', id);
  const routes = new RouteObject();

  return { permissions: routes.getGETRoutes(), statusCode: 200 };
};

const getPermission = async (id) => {
  const { client, statusCode } = await excecuteQueryAndHandleErrors('getPermission.sql', id);
  return { client, statusCode };
};

const createPermission = async (permission) => {
  const { statusCode } = await excecuteQueryAndHandleErrors('createPermission.sql', permission);
  return { statusCode };
};

const updatePermission = async (id, permission) => {
  const { statusCode } = await excecuteQueryAndHandleErrors('updatePermission.sql', id, permission);
  return { statusCode };
};

const getGroups = async () => {
  const { client, statusCode } = await excecuteQueryAndHandleErrors('getGroups.sql');
  return { client, statusCode };
};

const getGroup = async (id) => {
  const { client, statusCode } = await excecuteQueryAndHandleErrors('getGroup.sql', id);
  return { client, statusCode };
};

const createGroup = async (group) => {
  const { statusCode } = await excecuteQueryAndHandleErrors('createGroup.sql', group);
  return { statusCode };
};

const updateGroup = async (id, group) => {
  const { statusCode } = await excecuteQueryAndHandleErrors('updateGroup.sql', id, group);
  return { statusCode };
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
};
