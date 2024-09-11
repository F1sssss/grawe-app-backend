const sql = require('mssql');
/** @namespace  sql.Int**/
/** @namespace sql.VarChar **/
const bcrypt = require('bcryptjs');
const DBConnection = require('../DBConnection');
const DB_CONFIG = require('../DBconfig');
const SQLParam = require('../SQLParam');
const AppError = require('../../utils/AppError');
const { UserSignup } = require('./params');

const excecuteUserQuery = async (query, param, type = '') => {
  const connection = new DBConnection(DB_CONFIG.sql);
  const user = await connection.executeQuery(query, param);

  if (!user?.username && type !== 'signup' && type !== 'permissions') {
    throw new AppError(`User not found!`, 404, 'error-user-not-found');
  }

  if (type === 'login' && user.verified !== 1) {
    throw new AppError('Email not verified', 401, 'not-verified');
  }

  type !== 'signup' && type !== 'permissions'
    ? (user.password = type === 'login' ? user?.password : undefined)
    : type === 'permissions'
    ? user
    : undefined;

  return { user, statusCode: 200 };
};

const updateUserField = async (id, field, value) => {
  const connection = new DBConnection(DB_CONFIG.sql);

  if (typeof value === 'string') value = "'" + value + "'";

  const user = await connection.executeQuery(
    `update users set ${field} = ${value} where id = @id
           select * from users (nolock) where id = @id`,
    [new SQLParam('id', id, sql.Int)],
  );

  if (!user) {
    throw new AppError('Error updating user!', 401, 'error-updating-user-not-found');
  }

  if (user[field] !== value && `'${user[field]}'` !== value && field !== 'password' && field !== 'updated_at') {
    throw new AppError('Error updating user!', 401, 'error-updating-user-not-updated');
  }

  return { newValue: field !== 'password' ? user[field] : undefined, statusCode: 200 };
};

const getUserById = async (id) => {
  const { user, statusCode } = await excecuteUserQuery('select * from users (nolock) where id = @id', [new SQLParam('id', id, sql.Int)]);
  return { user, statusCode };
};

const getUserByUsername = async (username) => {
  const { user, statusCode } = await excecuteUserQuery('select * from users  (nolock) where username = @username and verified = 1', [
    new SQLParam('username', username, sql.VarChar),
  ]);

  return { user, statusCode };
};

const getUserByEmail = async (email) => {
  const { user, statusCode } = await excecuteUserQuery('select * from users  (nolock) where email = @email and verified = 1', [
    new SQLParam('email', email, sql.VarChar),
  ]);
  return { user, statusCode };
};

const getUserByUsernameOrEmail = async (username, email, requesttype) => {
  const { user, statusCode } = await excecuteUserQuery(
    'select * from users  (nolock) where username = @username or email = @email',
    [new SQLParam('username', username, sql.VarChar), new SQLParam('email', email, sql.VarChar)],
    requesttype,
  );

  return { user, statusCode };
};

const createUser = async (req) => {
  const { username, password, name, last_name, email, date_of_birth } = req;
  const verification_code = Math.floor(Math.random() * 1000000000);

  if (!username || !password || !name || !last_name || !email || !date_of_birth) {
    throw new AppError('Missing fields!', 401, 'error-missing-fields');
  }

  const { user } = await excecuteUserQuery(
    'signup.sql',
    UserSignup(username, password, name, last_name, email, date_of_birth, verification_code),
    'signup',
  );

  if (!user) {
    throw new AppError('Error creating user!', 401, 'error-creating-user');
  }

  return { user: { ...user, password: undefined }, statusCode: 200 };
};

const createADUser = async (ad_user) => {
  const { sAMAccountName: username, givenName: name, sn: last_name, mail: email } = ad_user;
  const verification_code = Math.floor(Math.random() * 1000000000);

  if (!username || !name || !last_name || !email) {
    throw new AppError('Missing fields!', 401, 'error-missing-fields');
  }

  const { user } = await excecuteUserQuery(
    'add_user_from_AD.sql',
    UserSignup(username, null, name, last_name, email, null, verification_code),
    'signup',
  );

  if (!user) {
    throw new AppError('Error creating user!', 401, 'error-creating-user');
  }

  return { user: { ...user, password: undefined }, statusCode: 200 };
};

const updateUserVerification = async (id, value) => {
  const { newValue, statusCode } = await updateUserField(id, 'verified', value);
  return { newValue, statusCode };
};

const updateUserPassword = async (id, value) => {
  const { newValue, statusCode } = await updateUserField(id, 'password', value);
  return { newValue, statusCode };
};

const updateUser = async (user, updatedUser) => {
  Object.keys(updatedUser).map(async (key) => {
    await updateUserField(user.ID, key, key === 'password' ? await bcrypt.hash(updatedUser[key], 12) : updatedUser[key]);
  });
  await updateUserField(user.ID, 'updated_at', new Date().toISOString());
  updatedUser = { ...updatedUser, password: undefined };
  return { updatedFields: updatedUser, statusCode: 200 };
};

const deleteUser = async (id) => {
  const connection = new DBConnection(DB_CONFIG.sql);
  const user = await connection.executeQuery(
    `delete from users where id = @id
           select * from users  (nolock) where id = @id`,
    [new SQLParam('id', id, sql.Int)],
  );

  if (user) {
    throw new AppError('Error deleting user!', 401, 'error-deleting-user-not-found');
  }

  return { message: 'User Deleted!', statusCode: 200 };
};

const getAllUsers = async () => {
  const connection = new DBConnection(DB_CONFIG.sql);
  const users = await connection.executeQuery('select * from users (nolock)');

  if (!users) {
    throw new AppError('Error getting users!', 401, 'error-getting-users');
  }

  return { users, statusCode: 200 };
};

const getUser = async (id) => {
  const { user, statusCode } = await excecuteUserQuery('select * from users (nolock) where id = @id', [new SQLParam('id', id, sql.Int)]);
  return { user, statusCode };
};

const getMyPermissions = async (id) => {
  const { user } = await excecuteUserQuery('get_permission_me.sql', [new SQLParam('id', id, sql.Int)], 'permissions');
  return { user, statusCode: 200 };
};

module.exports = {
  getUserById,
  getUserByUsername,
  getUserByEmail,
  getUserByUsernameOrEmail,
  createUser,
  updateUserVerification,
  updateUserPassword,
  updateUserField,
  updateUser,
  deleteUser,
  excecuteUserQuery,
  getAllUsers,
  getUser,
  getMyPermissions,
  createADUser,
};
