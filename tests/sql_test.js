module.exports = sql = {
  server: process.env.SQL_SERVER,
  database: process.env.SQL_DATABASE_TEST,
  user: process.env.SQL_USER,
  encrypt: false,
  password: process.env.SQL_PASSWORD,
  pool: {
    max: 20,
    min: 0,
    idleTimeoutMillis: 300000,
  },
};
