const path = require('path');
const dotenv = require('dotenv');
const assert = require('assert');

dotenv.config({
  path: path.resolve(process.cwd(), `.env`),
});

const defaultConfig = {
  env: process.env.NODE_ENV || 'development',
  isDevelopment: process.env.NODE_ENV !== 'production',
  isProduction: process.env.NODE_ENV === 'production',
  server: {
    port: parseInt(process.env.PORT, 10) || 3000,
    host: process.env.HOST || 'localhost',
    url: process.env.HOST_URL || 'http://localhost:3000',
    useSSL: process.env.USE_SSL === 'true',
    sslOptions:
      process.env.USE_SSL === 'true'
        ? {
            key: process.env.SSL_KEY_PATH,
            cert: process.env.SSL_CERT_PATH,
          }
        : null,
    apiVersion: process.env.API_VERSION || 'v1',
  },
  database: {
    useDocker: process.env.DB_USE_DOCKER === 'true',
    client: 'mssql',
    connection: {
      server: process.env.SQL_SERVER,
      port: parseInt(process.env.SQL_PORT || '1433', 10),
      database: process.env.SQL_DATABASE,
      user: process.env.SQL_USER,
      password: process.env.SQL_PASSWORD,
      encrypt: process.env.SQL_ENCRYPT === 'true',
      options: {
        requestTimeout: 1200000,
      },
      pool: {
        max: parseInt(process.env.SQL_POOL_MAX || '20', 10),
        min: parseInt(process.env.SQL_POOL_MIN || '0', 10),
        idleTimeoutMillis: parseInt(process.env.SQL_POOL_IDLE_TIMEOUT || '30000', 10),
      },
    },
  },
  auth: {
    jwt: {
      secret: process.env.JWT_ENCRYPT_PWD,
      expiresIn: process.env.JWT_EXPIRES_IN || '1h',
    },
    cookie: {
      secret: process.env.COOKIE_ENCRYPT_PWD,
    },
  },
  email: {
    service: process.env.EMAIL_SERVICE || 'SendGrid',
    apiKey: process.env.SENDGRID_API_KEY,
    from: process.env.EMAIL_FROM,
    fromName: process.env.EMAIL_FROM_NAME,
  },
  redis: {
    host: process.env.REDIS_HOST,
    port: parseInt(process.env.REDIS_PORT || '6379', 10),
    password: process.env.REDIS_PASSWORD,
    enabled: process.env.REDIS_ENABLED === 'true',
  },
  ldap: {
    url: process.env.LDAP_URL,
    baseDN: process.env.LDAP_BASE_DN,
    username: process.env.LDAP_USERNAME,
    password: process.env.LDAP_PASSWORD,
  },
  superset: {
    url: process.env.SUPERSET_URL,
    secretKey: process.env.SUPERSET_SECRET_KEY,
    databaseUri: process.env.SQLALCHEMY_DATABASE_URI,
    username: process.env.SUPERSET_USERNAME,
    password: process.env.SUPERSET_PASSWORD,
    user: {
      firstName: process.env.USER_FIRST_NAME,
      lastName: process.env.USER_LAST_NAME,
      username: process.env.USER_USERNAME,
    },
  },
  client: {
    ip: process.env.CLIENT_IP,
  },
  frontend: {
    url: process.env.FRONTEND_URL || 'http://localhost:3000',
  },
};

const commonRequiredKeys = ['JWT_ENCRYPT_PWD', 'COOKIE_ENCRYPT_PWD', 'SQL_SERVER', 'SQL_DATABASE', 'SQL_USER', 'SQL_PASSWORD'];

const productionRequiredKeys = [...commonRequiredKeys, 'REDIS_HOST', 'REDIS_PASSWORD'];

const requiredKeys = defaultConfig.isProduction ? productionRequiredKeys : commonRequiredKeys;
requiredKeys.forEach((key) => {
  assert(process.env[key], `${key} environment variable is required.`);
});

module.exports = defaultConfig;
