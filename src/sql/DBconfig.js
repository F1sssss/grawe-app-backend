'use strict';

const config = require('../config/config');

// Export the configuration information
module.exports = {
  port: config.server.port,
  host: config.server.host,
  url: config.server.url,
  cookiePwd: config.auth.cookie.secret,
  encrypt: config.auth.jwt.secret,
  expiresIn: config.auth.jwt.expiresIn,
  mailAPI: config.email.apiKey,
  sql: {
    server: config.database.connection.server,
    database: config.database.connection.database,
    user: config.database.connection.user,
    password: config.database.connection.password,
    port: config.database.connection.port,
    pool: config.database.connection.pool,
    options: {
      encrypt: config.database.connection.encrypt,
      requestTimeout: config.database.connection.options.requestTimeout,
    },
  },
};
