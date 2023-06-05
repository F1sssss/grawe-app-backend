'use strict';

const assert = require('assert');
const dotenv = require('dotenv');

dotenv.config({
  path: './config.env'
});

// capture the environment variables the application needs
const {
  PORT,
  HOST,
  HOST_URL,
  COOKIE_ENCRYPT_PWD,
  SQL_SERVER,
  SQL_DATABASE,
  SQL_USER,
  SQL_PASSWORD,
  JWT_ENCRYPT_PWD,
  JWT_EXPIRES_IN
} = process.env;

const isEncrypt = process.env.SQL_ENCRYPT === 'true';

// validate the required configuration information
[
  PORT,
  HOST,
  HOST_URL,
  COOKIE_ENCRYPT_PWD,
  SQL_SERVER,
  SQL_DATABASE,
  SQL_USER,
  SQL_PASSWORD
].map((item) => {
  assert(item, `${item} configuration is required.`);
});

// export the configuration information
module.exports = {
  port: PORT,
  host: HOST,
  url: HOST_URL,
  cookiePwd: COOKIE_ENCRYPT_PWD,
  encrypt: JWT_ENCRYPT_PWD,
  expiresIn: JWT_EXPIRES_IN,
  sql: {
    server: SQL_SERVER,
    database: SQL_DATABASE,
    user: SQL_USER,
    password: SQL_PASSWORD,
    options: {
      encrypt: isEncrypt
    }
  }
};
