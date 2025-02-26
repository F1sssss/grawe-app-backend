const logger = require('./winstonSetup');
const performanceMonitor = require('../utils/performanceMonitor');
const path = require('path');
const fs = require('fs');

function initializeLogging() {
  process.on('uncaughtException', (error) => {
    logger.error('Uncaught Exception', {
      type: 'uncaught-exception',
      error,
    });

    setTimeout(() => {
      process.exit(1);
    }, 1000);
  });

  process.on('unhandledRejection', (reason, promise) => {
    logger.error('Unhandled Rejection', {
      type: 'unhandled-rejection',
      reason,
      promise: promise.toString(),
    });
  });

  performanceMonitor.start();

  logger.info('Application logging initialized', {
    type: 'app-startup',
    environment: process.env.NODE_ENV,
    version: getAppVersion(),
    timestamp: new Date().toISOString(),
  });

  return {
    logger,
    performanceMonitor,
  };
}

function getAppVersion() {
  try {
    const packageJsonPath = path.join(process.cwd(), 'package.json');
    const packageJson = JSON.parse(fs.readFileSync(packageJsonPath, 'utf8'));
    return packageJson.version;
  } catch (error) {
    return 'unknown';
  }
}

module.exports = initializeLogging;
