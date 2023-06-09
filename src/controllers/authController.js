// Description: Controller for user authentication

/** @namespace req.body.last_name * **/
/** @namespace req.body.Date_of_birth * **/
/** @namespace req.body.email * **/
/** @namespace req.user.role * **/

const authServices = require('../services/authServices');
const AppError = require('../utils/appError');
const CatchAsync = require('../utils/catchAsync');

const login = CatchAsync(async (req, res, next) => {
  const { token, user, statusCode } = await authServices.loginService(req.body);

  if (!token || !user || statusCode !== 200) {
    throw next(new AppError('Error during user login:', statusCode));
  }

  res.cookie('token', token, {
    httpOnly: true,
    secure: req.secure || req.headers['x-forwarded-proto'] === 'https'
  });
  res.status(200).send({
    message: 'Login successful!',
    token,
    user
  });
  next();
});

const logout = CatchAsync(async (req, res, next) => {
  res.cookie('jwt', 'loggedOut', {
    httpOnly: true,
    expires: new Date(Date.now() + 10 * 1000)
  });

  res.status(200).json({ status: 'success' });
  next();
});

const signUp = CatchAsync(async (req, res, next) => {
  const { user, statusCode } = await authServices.signupService(req.body);

  if (statusCode !== 200) {
    throw next(new AppError('Error during user signup:', statusCode));
  }

  res.status(200).send({
    message: 'Signup successful!',
    user
  });

  next();
});

const forgotPassword = CatchAsync(async (req, res, next) => {
  const { user, statusCode } = await authServices.forgotPasswordService(
    req.params.id
  );

  if (statusCode !== 200 || !user) {
    throw next(new AppError('Error during resetting password', statusCode));
  }

  res.status(200).send({
    message: 'Password reset email sent!',
    user
  });

  next();
});

const emailVerification = CatchAsync(async (req, res, next) => {
  const { user, statusCode } = await authServices.verifyUserService(req.params);

  if (statusCode !== 200 || !user) {
    throw next(new AppError('Error during email verification', statusCode));
  }

  res.status(200).send({
    message: 'User verified!',
    user
  });

  next();
});

const protect = CatchAsync(async (req, res, next) => {
  const { token, user, statusCode } = await authServices.protectService(
    req.headers.authorization
  );

  if (!token || !user || statusCode !== 200) {
    throw next(new AppError('Error during user authentication!:', statusCode));
  }

  req.user = user;
  req.locals.user = user;

  next();
});

const restictTo = (...roles) => {
  return (req, res, next) => {
    if (!roles.includes(req.user.role)) {
      throw next(
        new AppError('You do not have permission to perform this action', 403)
      );
    }

    next();
  };
};

module.exports = {
  login,
  logout,
  signUp,
  forgotPassword,
  emailVerification,
  protect,
  restictTo
};
