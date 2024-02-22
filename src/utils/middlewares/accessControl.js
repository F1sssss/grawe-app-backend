const DBConnection = require('../../sql/DBConnection');
const DB_CONFIG = require('../../sql/DBconfig');
const AppError = require('../AppError');
const userServices = require('../../services/userServices');
const { AccessControl } = require('../../sql/Queries/params');
const CatchAsync = require('../CatchAsync');

const excecuteQueryAndHandleErrors = async (queryFileName, params) => {
  const connection = new DBConnection(DB_CONFIG.sql);
  const permissions = await connection.executeQuery(queryFileName, params);

  return { permissions, statusCode: 200 };
};

const accessControlMiddleware = async (req, res, next) => {
  const route = req.originalUrl;
  const id = req.params.id;
  const { user } = await userServices.getMeService(req);

  const { permissions } = await excecuteQueryAndHandleErrors('getPermissions.sql', AccessControl(route, user.ID, id));

  if (!permissions || permissions.length === 0) {
    throw new AppError('No permissions found', 404, 'error-access-control-middleware-no-permissions-found');
  }

  res.FilterFields = permissions
    .map((permission) => {
      if (permission.read_right === 1) {
        return permission.property_path;
      }
    })
    .filter((property) => property !== undefined);

  console.log('res.FilterFields', res.FilterFields);

  next();
};

module.exports = accessControlMiddleware;
