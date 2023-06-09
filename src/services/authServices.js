// Purpose: Service for user login.
// Description: This is a service for user login. It is called by the authController.js file.

/** @namespace user.verified**/

const jwt = require('jsonwebtoken');
const { promisify } = require('util');

const DB_CONFIG = require('../sql/DBConfig');
const EmailValidator = require('../utils/Email');
const SQLQueries = require('../sql/UserQueries');
const AppError = require('../utils/AppError');

const SignJWT = (username) => {
  return jwt.sign({ username }, DB_CONFIG.encrypt, {
    expiresIn: DB_CONFIG.expiresIn
  });
};

const loginService = async (req) => {
  const { username, password } = req;
  const { user } = await SQLQueries.getUserByUsername(username);

  if (password !== user.password) {
    throw new AppError('Invalid password', 401);
  }

  const token = SignJWT(username);

  user.password = null;

  return { token, user, statusCode: 200 };
};

const signupService = async (req) => {
  const { username, email } = req;

  await signupValidationService(req);

  const { user } = await SQLQueries.createUser(req);

  const Email = new EmailValidator(
    email,
    username,
    user.ID,
    user.email_verification_token
  );
  await Email.sendEmail();

  user.password = null;

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
  try {
    const user = await SQLQueries.getUserById(id);
    const Email = new EmailValidator(user[0].email, user[0].username);
    await Email.sendEmail();

    return { user, statusCode: 200 };
  } catch (err) {
    console.error('Error during user forgot password:', err);
    throw new AppError(err.message, 500);
  }
};

const checkNewAndOldPasswordService = async (id, password, newPassword) => {
  const user = await SQLQueries.getUserById(id);

  if (password !== user.password) {
    throw new AppError('Old Password is incorrect!', 400);
  }

  if (password === newPassword) {
    throw new AppError('Old Password and New Password cannot be same!', 400);
  }

  return { user, statusCode: 200 };
};

const checkEmailVerification = async (id, email_verification_token) => {
  const { user } = await SQLQueries.getUserById(id);

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

  await SQLQueries.updateUser(id, 'verified', 1);

  return { user, statusCode: 200 };
};

const protectService = async (req) => {
  let token;

  if (req && req.startsWith('Bearer')) {
    token = req.split(' ')[1];
  } else if (req.cookies.jwt) {
    token = req.cookies.jwt;
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
  checkNewAndOldPasswordService,
  checkEmailVerification,
  verifyUserService,
  protectService
};
