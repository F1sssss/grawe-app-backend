// Description: Controller for user authentication

/** @namespace req.body.last_name * **/
/** @namespace req.body.Date_of_birth * **/
/** @namespace req.body.email * **/
/** @namespace req.user.role * **/
/** @namespace req.body.newPassword, * **/

const authServices = require('../services/authServices');
const userServices = require('../services/userServices');
const AppError = require('../utils/appError');
const CatchAsync = require('../utils/catchAsync');

const login = CatchAsync(async (req, res) => {
  const { token, user, statusCode } = await authServices.loginService(req.body);

  res.cookie('token', token, {
    httpOnly: true,
    secure: req.secure || req.headers['x-forwarded-proto'] === 'https'
  });
  res.status(statusCode).send({
    message: 'Login successful!',
    token,
    user
  });
});

const logout = CatchAsync(async (req, res) => {
  res.cookie('token', 'loggedOut', {
    httpOnly: true,
    expires: new Date(Date.now() + 10 * 1000)
  });

  res.status(200).json({ status: 'success' });
});

const signUp = CatchAsync(async (req, res) => {
  const { user, statusCode } = await authServices.signupService(req.body);

  res.status(statusCode).send({
    message: 'Signup successful!',
    user
  });
});

const forgotPassword = CatchAsync(async (req, res) => {
  const { user, statusCode } = await authServices.forgotPasswordService(req.body.username);

  res.status(statusCode).send({
    message: 'Password reset email sent!',
    user
  });
});

const setNewPassword = CatchAsync(async (req, res) => {
  const { new_value, statusCode } = await authServices.setNewPasswordService(req.body.newPassword, req.query.id);

  res.status(statusCode).send({
    message: 'Password reset successful!',
    new_value
  });
});

const emailVerification = CatchAsync(async (req, res) => {
  const { user, statusCode } = await authServices.verifyUserService(req.query);

  res.status(statusCode).send({
    message: 'User verified!',
    user
  });
});

const protect = CatchAsync(async (req, res, next) => {
  const { user } = await userServices.getMeService(req);

  req.user = user;
  //res.local.user = user;
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
  setNewPassword
};
