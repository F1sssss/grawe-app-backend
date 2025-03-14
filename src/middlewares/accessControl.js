const DBConnection = require('../sql/DBConnection');
const DB_CONFIG = require('../sql/DBconfig');
const AppError = require('../utils/AppError');
const userServices = require('../services/userService');
const { AccessControl } = require('../sql/Queries/params');
const CatchAsync = require('./CatchAsync');
const logger = require('../logging/winstonSetup');

const executeQueryAndHandleErrors = async (queryFileName, params) => {
  const connection = new DBConnection(DB_CONFIG.sql);
  const permissions = await connection.executeQuery(queryFileName, params);

  return { permissions, statusCode: 200 };
};

const accessControlMiddleware = CatchAsync(async (req, res, next) => {
  const route = req.originalUrl;
  const method = req.method.toLowerCase();
  const id = req.params.id;

  const { user } = await userServices.getMeService(req, res, next);

  if (!user) {
    throw new AppError('User not logged in!', 401, 'error-access-control-middleware-user-not-logged-in');
  }

  const { permissions } = await executeQueryAndHandleErrors('get_permission_for_user.sql', AccessControl(route, user.ID, id));

  if (!permissions || permissions.length === 0) {
    throw new AppError('No permissions found', 403, 'error-access-control-middleware-no-permissions-found');
  }

  req.userPermissions = permissions;

  if (['post', 'put', 'patch', 'delete'].includes(method)) {
    const hasWritePermission = permissions.some((p) => p.property_path === null);

    if (!hasWritePermission) {
      throw new AppError(
        `You don't have permission to ${method.toUpperCase()} on this resource`,
        403,
        'error-access-control-middleware-write-permission-denied',
      );
    }
  } else if (method === 'get') {
    res.FilterFields = permissions
      .filter((p) => p.read_right === 1)
      .map((p) => p.property_path)
      .filter((field) => field !== null && field !== undefined);

    const originalJson = res.json;
    res.json = function (data) {
      try {
        if (res.FilterFields === null) {
          return originalJson.call(this, data);
        }

        const filteredData = filterData(data, res.FilterFields);
        return originalJson.call(this, filteredData);
      } catch (error) {
        logger.error(`Error filtering response: ${error.message}`);
        return originalJson.call(this, { error: 'Error processing response data' });
      }
    };
  }

  logger.debug(`Access granted for ${method.toUpperCase()} ${route} by user ${user.ID}`);
  next();
});

function filterData(data, permittedFields) {
  if (!data) return data;

  if (!permittedFields || permittedFields.length === 0) return {};

  // Special case for arrays of objects with report_name property
  if (Array.isArray(data) && data.length > 0 && data[0] && typeof data[0] === 'object' && 'report_name' in data[0]) {
    return data.filter((item) => permittedFields.includes(item.report_name));
  }

  if (Array.isArray(data)) {
    return data.map((item) => filterData(item, permittedFields));
  }

  if (typeof data !== 'object' || data === null) return data;

  const result = {};

  for (const field of permittedFields) {
    if (field === null || field === undefined) continue;
    if (field in data) {
      result[field] = data[field];
    }
  }

  return result;
}

module.exports = accessControlMiddleware;
