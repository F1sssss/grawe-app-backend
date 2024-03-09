const { promisify } = require('util');
const AppError = require('../utils/AppError');
const jwt = require('jsonwebtoken');
const DB_CONFIG = require('../sql/DBconfig');
const SQLQueries = require('../sql/Queries/UserQueries');

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
  const { user } = await getAccessTokenAndUser(req);

  const { permissions } = await SQLQueries.getMyPermissions(user.ID);

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
