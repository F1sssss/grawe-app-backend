// Description: Main entry point for the application. Starts the server and connects to the database.
const app = require('./app');
const DB_CONFIG = require('./src/sql/DBconfig');
const DBConnection = require('./src/sql/DBConnection');
const connection = new DBConnection(DB_CONFIG.sql);
const cachingService = require('./src/services/cachingService');
const { logger } = require('./src/logging/winstonSetup');

const server = app.listen(DB_CONFIG.port, async () => {
  console.log(`🌐 App running on port  ${DB_CONFIG.port}...`);

  try {
    await connection.connect();
    await cachingService.connectToRedis();
  } catch (err) {
    console.log(err);
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

process.on('unhandledRejection', (err) => {
  logger.error(err);
});
