// Description: Main entry point for the application. Starts the server and connects to the database.

const app = require('./app');
const DB_CONFIG = require('./src/sql/DBconfig');
const DBConnection = require('./src/sql/DBConnect');

//Test connection to MSSQL database and start server

const server = app.listen(DB_CONFIG.port, async () => {
  console.log(`App running on port  ${DB_CONFIG.port}...`);

  const connection = new DBConnection(DB_CONFIG.sql);

  try {
    await connection.connect();
    await connection.close();
  } catch (err) {
    console.log('Error connecting to MSSQL database server.js');
    console.log(err);
    process.exit(1);
  }
});

//Error handling

process.on('unhandledRejection', (err) => {
  console.log('UNHANDLED REJECTION! 💥 Shutting down...');
  console.log(err.name, err.message);
  server.close(() => {
    process.exit(1);
  });
});

process.on('SIGTERM', () => {
  console.log('👋 SIGTERM RECEIVED. Shutting down gracefully');
  server.close(() => {
    console.log('💥 Process terminated!');
  });
});
