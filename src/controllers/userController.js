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

module.exports = {
  getMe,
  updateMe,
  deleteMe,
};
