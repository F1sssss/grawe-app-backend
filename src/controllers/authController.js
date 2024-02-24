// Description: Controller for user authentication
//It also contains the protect and restrictTo middleware functions

/** @namespace req.body.last_name * **/
/** @namespace req.body.Date_of_birth * **/
/** @namespace req.body.email * **/
/** @namespace req.user.role * **/
/** @namespace req.body.newPassword, * **/

const authServices = require('../services/authServices');
const userServices = require('../services/userServices');
const AppError = require('../utils/AppError');
const CatchAsync = require('../utils/CatchAsync');
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
  await responseHandler(authServices.signupService(req.body), res, { statusCode: 201 }, 'Signup successful!');
});

const forgotPassword = CatchAsync(async (req, res) => {
  await responseHandler(authServices.forgotPasswordService(req.body.username), res, { statusCode: 200 }, 'Password reset email sent!');
});

const setNewPassword = CatchAsync(async (req, res) => {
  await responseHandler(authServices.setNewPasswordService(req.body.newPassword, req.query.id), res, { statusCode: 200 }, 'Successful!');
});

const emailVerification = CatchAsync(async (req, res) => {
  await responseHandler(authServices.verifyUserService(req.query.id, req.query.token), res, { statusCode: 200 }, 'Email verification successful!');
});

const protect = CatchAsync(async (req, res, next) => {
  const { user } = await userServices.getMeService(req, res, next);
  req.user = user;
  next();
});

const restictTo = (...roles) => {
  return (req, res, next) => {
    if (!roles.includes(req.user.role)) {
      throw next(new AppError('You do not have permission to perform this action', 403, 'error-permission-denied'));
    }
  };
};

module.exports = {
  login,
  logout,
  signUp,
  forgotPassword,
  emailVerification,
  protect,
  restictTo,
  setNewPassword,
};
