const app = require('./app');
const DB_CONFIG = require('./src/sql/DBconfig');
const DBConnection = require('./src/sql/DBConnection');
const connection = new DBConnection(DB_CONFIG.sql);
const cachingService = require('./src/services/cachingService');
const logger = require('./src/logging/winstonSetup');
const performanceMonitor = require('./src/utils/performanceMonitor');

const server = app.listen(DB_CONFIG.port, async () => {
  try {
    await connection.connect();
    logger.info(`Server running on port ${DB_CONFIG.port}`, {
      type: 'server-start',
      port: DB_CONFIG.port,
      environment: process.env.NODE_ENV,
    });

    // Start performance monitoring
    performanceMonitor.start();

    if (process.env.NODE_ENV !== 'test') {
      await cachingService.connectToRedis();
    }
  } catch (err) {
    logger.error('Failed to start server', { error: err });
    process.exit(1);
  }
});

process.on('SIGTERM', async () => {
  logger.info('SIGTERM signal received, shutting down gracefully');

  // Stop performance monitoring
  performanceMonitor.stop();

  try {
    await connection.close();
    server.close(() => {
      logger.info('Server shut down successfully');
      process.exit(0);
    });
  } catch (err) {
    logger.error('Error closing connection pool', { error: err });
    process.exit(1);
  }
});
