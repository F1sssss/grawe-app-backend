const sql = require('mssql');
/** @namespace  sql.Int**/
/** @namespace sql.VarChar **/
const DBConnection = require('./DBConnection');
const DB_CONFIG = require('./DBconfig');
const SQLParam = require('./SQLParam');
const AppError = require('../utils/AppError');

const getUserById = async (id) => {
  const connection = new DBConnection(DB_CONFIG.sql);
  const user = await connection.executeQuery(
    'select * from users where id = @id',
    [new SQLParam('id', id, sql.Int)]
  );

  if (!user) {
    throw new AppError('User not found by id!', 404);
  }
  return { user, statusCode: 200 };
};

const getUserByUsername = async (username) => {
  const connection = new DBConnection(DB_CONFIG.sql);

  const user = await connection.executeQuery(
    'select * from users where username = @username',
    [new SQLParam('username', username, sql.VarChar)]
  );
  if (!user) {
    throw new AppError('User not found by username!', 404);
  }
  return { user, statusCode: 200 };
};

const getUserByEmail = async (email) => {
  const connection = new DBConnection(DB_CONFIG.sql);

  const user = await connection.executeQuery(
    'select * from users where email = @email',
    [new SQLParam('email', email, sql.VarChar)]
  );
  if (!user) {
    throw new AppError('User not found by username!', 404);
  }
  return { user, statusCode: 200 };
};

const getUserByUsernameOrEmail = async (username, email) => {
  const connection = new DBConnection(DB_CONFIG.sql);
  const user = await connection.executeQuery(
    'select * from users where username = @username or email = @email',
    [
      new SQLParam('username', username, sql.VarChar),
      new SQLParam('email', email, sql.VarChar)
    ]
  );
  if (!user) {
    throw new AppError('User not found by username or email!', 404);
  }
  return { user, statusCode: 200 };
};

const createUser = async (req) => {
  const connection = new DBConnection(DB_CONFIG.sql);
  const { username, password, name, last_name, email, date_of_birth } = req;
  const verification_code = Math.floor(Math.random() * 1000000000);
  const user = await connection.executeQuery(
    `insert into users(username,password,name,last_name,email,date_of_birth,verified,time_to_varify,created_at,email_verification_token) values(@username,@password,@name,@last_name,@email,@DOB,0,DATEADD(mi,10,GETDATE()),GETDATE(),${verification_code}) select * from users where username=@username`,
    [
      new SQLParam('username', username, sql.VarChar),
      new SQLParam('password', password, sql.VarChar),
      new SQLParam('name', name, sql.VarChar),
      new SQLParam('last_name', last_name, sql.VarChar),
      new SQLParam('email', email, sql.VarChar),
      new SQLParam('DOB', date_of_birth, sql.VarChar)
    ]
  );
  if (!user) {
    throw new AppError('Error creating user!', 401);
  }
  return { user, statusCode: 200 };
};

const updateUser = async (id, field, value) => {
  const connection = new DBConnection(DB_CONFIG.sql);
  const { verified } = await connection.executeQuery(
    `update users set ${field} = ${value} where id = @id 
            select ${field} from users where id = @id`,
    [new SQLParam('id', id, sql.Int)]
  );

  if (verified !== value) {
    throw new AppError('Error updating user!', 401);
  }

  return { new_value: verified, statusCode: 200 };
};

module.exports = {
  getUserById,
  getUserByUsername,
  getUserByEmail,
  getUserByUsernameOrEmail,
  createUser,
  updateUser
};
