// Purpose: Service for user login.
// Description: This is a service for user login. It is called by the authController.js file.
const jwt = require('jsonwebtoken');
const DBConnection = require('../sql/DBConnect');
const DB_CONFIG = require('../sql/DBConfig');
const loadSqlQueries = require('../utils/loadSQL');

const SignJWT = (username) => {
  return jwt.sign({ username }, DB_CONFIG.encrypt, {
    expiresIn: DB_CONFIG.expiresIn
  });
};

module.exports = loginService = async (username, password) => {
  try {
    const connection = new DBConnection(DB_CONFIG.sql);
    const userLoginQuery = await loadSqlQueries('login.sql');
    const user = await connection.executeQuery(userLoginQuery);

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
