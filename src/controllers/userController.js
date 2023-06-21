const userService = require('../services/userServices');
const responseHandler = require('../utils/responseHandler');

const getMe = async (req, res) => {
  await responseHandler(userService.getMeService(req), res, { statusCode: 200 }, 'success');
};

module.exports = {
  getMe,
};
