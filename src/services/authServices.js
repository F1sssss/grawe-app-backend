// Purpose: Service for user login.
// Description: This is a service for user login. It is called by the authController.js file.
const jwt = require('jsonwebtoken');
const sql = require('mssql');

const DBConnection = require('../sql/DBConnect');
const DB_CONFIG = require('../sql/DBConfig');
const loadSqlQueries = require('../utils/loadSQL');

const SignJWT = (username) => {
  return jwt.sign({ username }, DB_CONFIG.encrypt, {
    expiresIn: DB_CONFIG.expiresIn
  });
};

const loginService = async (username, password) => {
  try {
    const connection = new DBConnection(DB_CONFIG.sql);
    const userLoginQuery = await loadSqlQueries('login.sql');
    const params = [{ name: 'username', value: username, type: sql.VarChar }];
    const user = await connection.executeQuery(userLoginQuery, params);

    console.log(user);

    if (password !== user[0].password) {
      return { token: null, user: null, statusCode: 401 };
    }

    const token = SignJWT(username);

    user[0].password = null;

    return { token, user: user[0], statusCode: 200 };
  } catch (err) {
    console.error('Error during user login:', err);
    console.log(err);
    return { token: null, user: null, statusCode: 500 };
  }
};

const signupService = async (
  username,
  password,
  name,
  last_name,
  email,
  DOB
) => {
  try {
    const connection = new DBConnection(DB_CONFIG.sql);
    const userSignupQuery = await loadSqlQueries('signup.sql');

    const params = [
      { name: 'username', value: username, type: sql.VarChar },
      { name: 'name', value: name, type: sql.VarChar },
      { name: 'password', value: password, type: sql.VarChar },
      { name: 'last_name', value: last_name, type: sql.VarChar },
      { name: 'email', value: email, type: sql.VarChar },
      { name: 'DOB', value: DOB, type: sql.VarChar }
    ];

    const user = await connection.executeQuery(userSignupQuery, params);

    const token = SignJWT(username);

    user[0].password = null;

    return { token, user: user[0], statusCode: 200 };
  } catch (err) {
    console.error('Error during user signup:', err);
    console.log(err);
    return { token: null, user: null, statusCode: 500 };
  }
};

module.exports = { loginService, signupService };
