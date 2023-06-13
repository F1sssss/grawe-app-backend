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

  if (user.verified === 0) {
    throw new AppError('Email not verified', 401);
  }

  bcrypt.compare(password, user.password),
    (err) => {
      if (err) {
        throw new AppError('Invalid password', 401);
      }
    };

  const token = signJWT(username);

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
    throw new AppError('Error during sending email', 401);
  }

  return { user, statusCode: 200 };
};

const signupValidationService = async (req) => {
  const { username, email, password } = req;
  const { user } = await SQLQueries.getUserByUsernameOrEmail(username, email);

  const { emailRegex, emailRegexGrawe, passwordRegex } = {
    emailRegex: /^[^\s@]+@[^\s@]+\.[^\s@]+$/,
    emailRegexGrawe: /^[^\s@]+(\.[^\s@]+)?@grawe\.me$/,
    passwordRegex:
      /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[!@#$%^&*()])[A-Za-z\d!@#$%^&*()]{6,}$/
  };

  if (user) {
    if (username === user.username) {
      throw new AppError('Username already exists', 401);
    }

    if (email === user.email) {
      throw new AppError('Email already exists', 401);
    }
  }

  if (!emailRegex.test(email)) {
    throw new AppError('Invalid email', 401);
  }

  if (!emailRegexGrawe.test(email)) {
    //throw new AppError('Invalid Grawe email!', 401);
  }

  if (!passwordRegex.test(password)) {
    throw new AppError(
      'Invalid Password! Please insure there is at least one digit, one capital letter and one sign',
      401
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
    throw new AppError('Error during sending email', 401);
  }

  return { user, statusCode };
};

const checkEmailVerification = async (id, email_verification_token) => {
  const { user } = await SQLQueries.getUserById(id);

  if (user.time_to_varify < Date.now()) {
    throw new AppError('Email verification token expired!', 400);
  }

  if (email_verification_token !== user.email_verification_token) {
    throw new AppError('Invalid email verification token!', 400);
  }

  return { user, statusCode: 200 };
};

const verifyUserService = async (req) => {
  const { id, token } = req;
  const { user } = await checkEmailVerification(id, token);

  if (user.verified) {
    throw new AppError('User is already verified!', 400);
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
      401
    );
  }

  const decoded = await promisify(jwt.verify)(token, DB_CONFIG.encrypt);

  const { user } = await SQLQueries.getUserById(decoded.ID);

  if (!user) {
    throw new AppError(
      'The user belonging to this token does no longer exist.',
      401
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
