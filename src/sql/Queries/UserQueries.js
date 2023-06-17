const sql = require('mssql');
/** @namespace  sql.Int**/
/** @namespace sql.VarChar **/
const DBConnection = require('../DBConnection');
const DB_CONFIG = require('../DBconfig');
const SQLParam = require('../SQLParam');
const AppError = require('../../utils/AppError');
const loadSqlQueries = require('../sql_queries/loadSQL');
const { UserSignup } = require('./params');

const selectFromUsers = async (query, param, type = '') => {
  const connection = new DBConnection(DB_CONFIG.sql);
  if (query.includes('.sql')) {
    query = loadSqlQueries(query);
  }
  const user = await connection.executeQuery(query, param);
  if (!user.username && type !== 'signup') {
    throw new AppError(`User not found!`, 404, 'error-user-not-found');
  }
  if (type === 'login' && user.verified !== 1) {
    throw new AppError('Email not verified', 401, 'not-verified');
  }
  user.password = type === 'login' ? user.password : undefined;
  return { user, statusCode: 200 };
};

const updateUser = async (id, field, value) => {
  const connection = new DBConnection(DB_CONFIG.sql);

  if (typeof value === 'string') value = "'" + value + "'";

  const user = await connection.executeQuery(
    `update users set ${field} = ${value} where id = @id
           select * from users where id = @id`,
    [new SQLParam('id', id, sql.Int)],
  );

  if (!user) {
    throw new AppError('Error updating user!', 401, 'error-updating-user-not-found');
  }

  if (user[field] !== value) {
    throw new AppError('Error updating user!', 401, 'error-updating-user-not-updated');
  }
  return { newValue: field !== 'password' ? user[field] : undefined, statusCode: 200 };
};

const getUserById = async (id) => {
  const { user, statusCode } = await selectFromUsers('select * from users where id = @id', [new SQLParam('id', id, sql.Int)]);
  return { user, statusCode };
};

const getUserByUsername = async (username) => {
  const { user, statusCode } = await selectFromUsers('select * from users where username = @username and verified = 1', [
    new SQLParam('username', username, sql.VarChar),
  ]);

  return { user, statusCode };
};

const getUserByEmail = async (email) => {
  const { user, statusCode } = await selectFromUsers('select * from users where username = @username and verified = 1', [
    new SQLParam('email', email, sql.VarChar),
  ]);
  return { user, statusCode };
};

const getUserByUsernameOrEmail = async (username, email, requesttype) => {
  const { user, statusCode } = await selectFromUsers(
    'select * from users where username = @username or email = @email',
    [new SQLParam('username', username, sql.VarChar), new SQLParam('email', email, sql.VarChar)],
    requesttype,
  );
  return { user, statusCode };
};

const createUser = async (req) => {
  const connection = new DBConnection(DB_CONFIG.sql);
  const { username, password, name, last_name, email, date_of_birth } = req;
  const verification_code = Math.floor(Math.random() * 1000000000);

  const user = await connection.executeQuery(
    await loadSqlQueries('signup.sql'),
    UserSignup(username, password, name, last_name, email, date_of_birth, verification_code),
  );
  if (!user) {
    throw new AppError('Error creating user!', 401, 'error-creating-user');
  }

  return { user: { ...user, password: undefined }, statusCode: 200 };
};

const updateUserVerification = async (id, field, value) => {
  const { user, statusCode } = await updateUser(id, field, value);
  return { user, statusCode };
};

const updateUserPassword = async (id, field, value) => {
  const { user, statusCode } = await updateUser(id, field, value);
  return { user, statusCode };
};

module.exports = {
  getUserById,
  getUserByUsername,
  getUserByEmail,
  getUserByUsernameOrEmail,
  createUser,
  updateUserVerification,
  updateUserPassword,
};
