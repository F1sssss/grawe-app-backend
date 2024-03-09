const userService = require('../services/userServices');
const responseHandler = require('../utils/responseHandler');

const getMe = async (req, res) => {
  await responseHandler(userService.getMeService(req), res, { statusCode: 200 });
};

const updateMe = async (req, res) => {
  await responseHandler(userService.updateMeService(req), res, { statusCode: 200 });
};

const deleteMe = async (req, res) => {
  await responseHandler(userService.deleteMeService(req), res, { statusCode: 204 });
};

const getAllUsers = async (req, res) => {
  await responseHandler(userService.getAllUsersService(req), res, { statusCode: 200 });
};

const getUser = async (req, res) => {
  await responseHandler(userService.getUserService(req), res, { statusCode: 200 });
};

const getMyPermissions = async (req, res) => {
  await responseHandler(userService.getMyPermissionsService(req), res, { statusCode: 200 });
};

module.exports = {
  getMe,
  updateMe,
  deleteMe,
  getAllUsers,
  getUser,
  getMyPermissions,
};
