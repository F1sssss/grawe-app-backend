// Purpose: Service for user login.
// Description: This is a service for user login. It is called by the authController.js file.

/** @namespace user.verified**/
/** @namespace user.time_to_varify**/

const jwt = require('jsonwebtoken');
const bcrypt = require('bcryptjs');
const { promisify } = require('util');

const DB_CONFIG = require('../sql/DBConfig');
const EmailValidator = require('../utils/Email');
const SQLQueries = require('../sql/Queries/UserQueries');
const AppError = require('../utils/AppError');
const ValidationRegex = require('../utils/ValidationRegex');

const signJWT = (username) => {
  return jwt.sign({ username }, DB_CONFIG.encrypt, {
    expiresIn: DB_CONFIG.expiresIn
  });
};

const loginService = async (req) => {
  const { username, password } = req;

  const { user } = await SQLQueries.getUserByUsernameOrEmail(
    username,
    username,
    'login'
  );

  if (!(await bcrypt.compare(password, user.password))) {
    throw new AppError('Invalid Password', 401, 'error-invalid-password');
  }

  const token = signJWT(username);

  user.password = undefined;
  return { token, user, statusCode: 200 };
};

const signupService = async (req) => {
  const { username, email } = req;

  await signupValidationService(req);

  req.password = await bcrypt.hash(req.password, 12);

  const { user } = await SQLQueries.createUser(req);

  const Email = new EmailValidator(
    email,
    username,
    user.ID,
    user.email_verification_token
  );
  const emailsent = await Email.sendEmailVerification();

  if (!emailsent) {
    throw new AppError(
      'Error during sending email',
      401,
      'error-email-sending-verification'
    );
  }

  return { user, statusCode: 200 };
};

const signupValidationService = async (req) => {
  const { username, email, password } = req;
  const { user } = await SQLQueries.getUserByUsernameOrEmail(username, email); // This one will throw and return 404 if user not found :( So no one can get registered

  if (user) {
    if (username === user.username) {
      throw new AppError(
        'Username already exists',
        401,
        'error-username-exists'
      );
    }

    if (email === user.email) {
      throw new AppError('Email already exists', 401, 'error-email-exists');
    }
  }

  // Would have never been reached in its previous location
  if (!ValidationRegex.usernameRegex.test(username)) {
    throw new AppError(
      'Invalid Username! Please insure it contains only letters and numbers and minimum 6 characters',
      401,
      'error-invalid-username'
    );
  }

  if (!ValidationRegex.emailRegex.test(email)) {
    throw new AppError('Invalid email', 401, 'error-invalid-email');
  }

  if (!ValidationRegex.emailRegexGrawe.test(email)) {
    //throw new AppError('Invalid Grawe email!', 401, 'error-invalid-email');
  }

  if (!ValidationRegex.passwordRegex.test(password)) {
    throw new AppError(
      'Invalid Password! Please insure there is at least one digit, one capital letter and one sign',
      401,
      'error-invalid-password'
    );
  }
  return { message: 'Valid parameters!', statusCode: 200 };
};

const forgotPasswordService = async (id) => {
  const { user, statusCode } = await SQLQueries.getUserByUsernameOrEmail(id);

  const Email = new EmailValidator(
    user.email,
    user.username,
    user.id,
    user.email_verification_token
  );

  const emailsent = await Email.sendEmailRetrievingPassword();

  if (!emailsent || statusCode !== 200) {
    throw new AppError(
      'Error during sending email',
      401,
      'error-email-sending-forgotpassword'
    );
  }

  return { user, statusCode };
};

const checkEmailVerification = async (id, email_verification_token) => {
  const { user } = await SQLQueries.getUserById(id);

  //Date.now() returns an integer,number of ms since 1970, and time to verify was a Date object, new Date() returns current time, via Date object
  if (user.time_to_varify < new Date()) {
    throw new AppError(
      'Email verification token expired!',
      400,
      'error-expired-email-verification-token'
    );
  }

  if (email_verification_token !== user.email_verification_token) {
    throw new AppError(
      'Invalid email verification token!',
      400,
      'error-invalid-email-verification-token'
    );
  }

  return { user, statusCode: 200 };
};

const verifyUserService = async (req) => {
  const { id, token } = req;
  const { user } = await checkEmailVerification(id, token);

  if (user.verified) {
    throw new AppError('User is already verified!', 400, 'error-user-verified');
  }

  await SQLQueries.updateUserVerification(id, 'verified', 1);

  return { user, statusCode: 200 };
};

const setNewPasswordService = async (newPassword, id) => {
  newPassword = await bcrypt.hash(newPassword, 12);

  const { new_value } = await SQLQueries.updateUserPassword(
    id,
    'password',
    newPassword
  );

  return { new_value, statusCode: 200 };
};

const protectService = async (req) => {
  let token;

  if (
    req.headers.authorization &&
    req.headers.authorization.startsWith('Bearer')
  ) {
    token = req.headers.authorization.split(' ')[1];
  } else if (req.cookies.token) {
    token = req.cookies.token;
  }

  if (!token) {
    throw new AppError(
      'You are not logged in! Please log in to get access.',
      401,
      'error-not-logged-in'
    );
  }

  const decoded = await promisify(jwt.verify)(token, DB_CONFIG.encrypt);

  const { user } = await SQLQueries.getUserById(decoded.ID);

  if (!user) {
    throw new AppError(
      'The user belonging to this token does no longer exist.',
      401,
      'error-user-no-longer-exist'
    );
  }

  return { token, user, statusCode: 200 };
};

module.exports = {
  loginService,
  signupService,
  forgotPasswordService,
  checkEmailVerification,
  verifyUserService,
  protectService,
  setNewPasswordService
};
