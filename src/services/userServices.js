const { promisify } = require('util');
const AppError = require('../utils/AppError');
const jwt = require('jsonwebtoken');
const DB_CONFIG = require('../sql/DBconfig');
const SQLQueries = require('../sql/Queries/UserQueries');
const { loggers } = require('winston');

const getAccessTokenAndUser = async (req) => {
  let token;
  if (req.headers.authorization && req.headers.authorization.startsWith('Bearer')) {
    token = req.headers.authorization.split(' ')[1];
  } else if (req.cookies.token) {
    token = req.cookies.token;
  }

  if (!token || token === 'loggedOut') {
    throw new AppError('You are not logged in! Please log in to get access.', 401, 'error-not-logged-in');
  }

  const decoded = await promisify(jwt.verify)(token, DB_CONFIG.encrypt);
  const { user } = await SQLQueries.getUserByUsernameOrEmail(decoded.username, decoded.username);

  if (!user) {
    throw new AppError('The user belonging to this token does no longer exist.', 401, 'error-user-no-longer-exist');
  }

  return { token, user };
};

const getMeService = async (req) => {
  return ({ token, user } = await getAccessTokenAndUser(req));
};

const updateMeService = async (data) => {
  return ({ updatedFields } = await SQLQueries.updateUser(data.user, data.body));
};

const deleteMeService = async (data) => {
  return ({ message } = await SQLQueries.deleteUser(data.user.ID));
};

const getAllUsersService = async (req) => {
  return ({ users } = await SQLQueries.getAllUsers());
};

const getUserService = async (req) => {
  return ({ user } = await SQLQueries.getUser(req.params.id));
};

const getMyPermissionsService = async (req) => {
  const {
    user: { ID },
  } = await getAccessTokenAndUser(req);
  const { user } = await SQLQueries.getMyPermissions(ID);

  if (!user) {
    return ['error-no-permissions'];
    //throw new AppError('The user does not have any permissions.', 401, 'error-no-permissions');
  }

  const permissions = user.reduce((result, item) => {
    const existingRoute = result.find((entry) => entry.route === item.route);
    const existingMethod = result.find((entry) => entry.methods[0] === item.method);

    if (existingRoute && existingMethod) {
      // If it exists, just push the property details to the existing entry
      existingRoute.properties.push({
        property_path: item.property_path,
        read_right: item.read_right,
        write_right: item.write_right,
      });
    } else if (existingRoute && !existingMethod) {
      // If entry exists, but method does not exist, add method and property details
      existingRoute.methods.push(item.method);
    } else {
      // If entry does not exist, create entry
      result.push({
        route: item.route,
        methods: [item.method],
        properties: [
          {
            property_path: item.property_path,
            read_right: item.read_right,
            write_right: item.write_right,
          },
        ],
      });
    }
    return result;
  }, []);

  return { permissions };
};

module.exports = {
  getMeService,
  updateMeService,
  deleteMeService,
  getAllUsersService,
  getUserService,
  getMyPermissionsService,
};
