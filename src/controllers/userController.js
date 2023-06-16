const userService = require('../services/userServices');

const getMe = async (req, res) => {
  const { user, statusCode } = await userService.getMeService(req);
  console.log(user);
  res.status(statusCode).send({
    message: 'User verified!',
    user
  });
};

module.exports = {
  getMe
};
