const { promisify } = require('util');

const AppError = require('../utils/appError');

const jwt = require('jsonwebtoken');
const DB_CONFIG = require('../sql/DBconfig');
const SQLQueries = require('../sql/Queries/UserQueries');

const getMeService = async (req) => {
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
    throw new AppError('The user belonging to this tken does no longer exist.', 401, 'error-user-no-longer-exist');
  }

  return { token, user, statusCode: 200 };
};

const updateMeService = async (data) => {
  const updatedUser = data.body;
  return ({ updatedFields } = await SQLQueries.updateUser(data.user, updatedUser));
};

const deleteMeService = async (data) => {
  return ({ message } = await SQLQueries.deleteUser(data.user.ID));
};

module.exports = {
  getMeService,
  updateMeService,
  deleteMeService,
};
