module.exports = sql = {
  server: '127.0.0.1',
  database: 'GRAWE_WEBAPP_TEST',
  user: process.env.SQL_USER,
  encrypt: false,
  password: process.env.SQL_PASSWORD,
  pool: {
    max: 20,
    min: 0,
    idleTimeoutMillis: 300000,
  },
};
