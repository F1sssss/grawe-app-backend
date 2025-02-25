const authServices = require('../services/authService');
const userServices = require('../services/userService');
const CatchAsync = require('../middlewares/CatchAsync');
const responseHandler = require('../utils/responseHandler');

const login = CatchAsync(async (req, res) => {
  const { token, user, statusCode } = await authServices.loginService(req.body.username, req.body.password);
  res.cookie('token', token, {
    httpOnly: true,
    secure: req.secure || req.headers['x-forwarded-proto'] === 'https',
  });
  res.status(statusCode).send({
    message: 'Login successful!',
    token,
    user,
  });
});

const logout = CatchAsync(async (req, res) => {
  res.cookie('token', 'loggedOut', {
    httpOnly: true,
    expires: new Date(Date.now() + 10 * 1000),
  });

  res.status(200).json({ status: 'success' });
});

const signUp = CatchAsync(async (req, res) => {
  await responseHandler(authServices.signupService(req.body), res, { statusCode: 201 });
});

const forgotPassword = CatchAsync(async (req, res) => {
  await responseHandler(authServices.forgotPasswordService(req.body.username), res, { statusCode: 200 });
});

const setNewPassword = CatchAsync(async (req, res) => {
  await responseHandler(authServices.setNewPasswordService(req.body.newPassword, req.query.id), res, { statusCode: 200 });
});

const emailVerification = CatchAsync(async (req, res) => {
  await responseHandler(authServices.verifyUserService(req.query.id, req.query.token), res, { statusCode: 200 });
});

const protect = CatchAsync(async (req, res, next) => {
  const { user } = await userServices.getMeService(req, res, next);
  req.user = user;
  next();
});

module.exports = {
  login,
  logout,
  signUp,
  forgotPassword,
  emailVerification,
  protect,
  setNewPassword,
};
