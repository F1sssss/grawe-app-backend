// Description: Main entry point for the application. Starts the server and connects to the database.
const app = require('./app');
const DB_CONFIG = require('./src/sql/DBconfig');
const DBConnection = require('./src/sql/DBConnection');
const Policy = require('./src/sql/Queries/PoliciesQueries');
const connection = new DBConnection(DB_CONFIG.sql);

const server = app.listen(DB_CONFIG.port, async () => {
  console.log(`App running on port  ${DB_CONFIG.port}...`);

  try {
    await connection.connect();
  } catch (err) {
    console.log('Error connecting to MSSQL database server.js');
    console.log(err);
    process.exit(1);
  }
});

//Error handling

process.on('unhandledRejection', async (err) => {
  console.log('UNHANDLED REJECTION! 💥 Shutting down...');
  console.log(err.name, err.message);

  try {
    await connection.close();
    server.close(() => {
      process.exit(1);
    });
  } catch (err) {
    console.error('Error closing connection pool:', err);
    process.exit(1);
  }
});

process.on('SIGTERM', async () => {
  console.log('👋 SIGTERM RECEIVED. Shutting down gracefully');

  try {
    await connection.close();
    server.close(() => {
      console.log('💥 Process terminated!');
      process.exit(0);
    });
  } catch (err) {
    console.error('Error closing connection pool:', err);
    process.exit(1);
  }
});
