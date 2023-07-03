// Purpose: Service for user login.
// Description: This is a service for user login. It is called by the authController.js file.

/** @namespace user.verified**/
/** @namespace user.time_to_varify**/

const jwt = require('jsonwebtoken');
const bcrypt = require('bcryptjs');

const DB_CONFIG = require('../sql/DBConfig');
const EmailValidator = require('../utils/Email');
const SQLQueries = require('../sql/Queries/UserQueries');
const AppError = require('../utils/AppError');
const ValidationRegex = require('../utils/ValidationRegex');

const signJWT = (username) => {
  return jwt.sign({ username }, DB_CONFIG.encrypt, {
    expiresIn: DB_CONFIG.expiresIn,
  });
};

const loginService = async (username, password) => {
  const { user } = await SQLQueries.getUserByUsernameOrEmail(username, username, 'login');

  if (!(await bcrypt.compare(password, user.password))) {
    throw new AppError('Invalid Password', 401, 'error-invalid-password');
  }

  const token = signJWT(username);

  return { token, user: { ...user, password: undefined }, statusCode: 200 };
};

const signupService = async (req) => {
  await signupFieldValidationService(req);

  const { user } = await SQLQueries.createUser({ ...req, password: await bcrypt.hash(req.password, 12) });

  const Email = new EmailValidator(user);
  await Email.sendEmailVerification();

  return { message: 'User created successfully!', user, statusCode: 201 };
};

const signupFieldValidationService = async (req) => {
  const { username, email, password } = req;

  const { user } = await SQLQueries.getUserByUsernameOrEmail(username, email, 'signup');

  if (user) {
    if (username === user.username) {
      throw new AppError('Username already exists', 401, 'error-username-exists');
    }

    if (email === user.email) {
      throw new AppError('Email already exists', 401, 'error-email-exists');
    }
  }

  if (!ValidationRegex.usernameRegex.test(username)) {
    throw new AppError(
      'Invalid Username! Please insure it contains only letters and numbers and minimum 6 characters',
      401,
      'error-invalid-username',
    );
  }

  if (!ValidationRegex.emailRegex.test(email)) {
    throw new AppError('Invalid email', 401, 'error-invalid-email');
  }

  if (!ValidationRegex.emailRegexGrawe.test(email)) {
    //throw new AppError('Invalid Grawe email!', 401, 'error-invalid-email');
  }

  if (!ValidationRegex.passwordRegex.test(password)) {
    throw new AppError('Invalid Password! Please insure there is at least one digit, one capital letter and one sign', 401, 'error-invalid-password');
  }
  return { message: 'Valid parameters!', statusCode: 200 };
};

const forgotPasswordService = async (id) => {
  const { user } = await SQLQueries.getUserByUsernameOrEmail(id);

  const Email = new EmailValidator(user);
  await Email.sendEmailRetrievingPassword();

  return { user, statusCode: 200 };
};

const checkVerificationToken = async (id, email_verification_token) => {
  const { user } = await SQLQueries.getUserById(id);

  if (user.verified) {
    throw new AppError('User is already verified!', 400, 'error-user-verified');
  }

  if (user.time_to_varify < new Date()) {
    throw new AppError('Email verification token expired!', 400, 'error-expired-email-verification-token');
  }

  if (email_verification_token !== user.email_verification_token) {
    throw new AppError('Invalid email verification token!', 400, 'error-invalid-email-verification-token');
  }

  return { user, statusCode: 200 };
};

const verifyUserService = async (id, token) => {
  const { user } = await checkVerificationToken(id, token);
  await SQLQueries.updateUserVerification(id, 1);

  return { user, statusCode: 200 };
};

const setNewPasswordService = async (newPassword, id) => {
  return ({ new_value, statusCode } = await SQLQueries.updateUserPassword(id, await bcrypt.hash(newPassword, 12)));
};

module.exports = {
  loginService,
  signupService,
  forgotPasswordService,
  verifyUserService,
  setNewPasswordService,
  signupFieldValidationService,
  checkVerificationToken,
};
