const { EventEmitter } = require('events');
const cachingService = require('../services/cachingService');
const logger = require('../logging/winstonSetup');

module.exports = class ReportQueue extends EventEmitter {
  constructor() {
    super();
    this.queue = new Map();
  }

  async getOrQueueReport(reportId, inputParams, generateReportFn) {
    const key = `report-${reportId}-${JSON.stringify(inputParams).replace(':', '')}`;

    // Check cache first
    try {
      const cachedResult = await cachingService.get(key);
      if (cachedResult) {
        return { status: 'completed', data: cachedResult };
      }
    } catch (error) {
      logger.warn(`Error checking Redis cache: ${error.message}`);
    }

    // If report is already being generated, wait for it
    if (this.queue.has(key)) {
      logger.info(`Waiting for in-progress report: ${key}`);
      return new Promise((resolve) => {
        this.once(`report-${key}`, (result) => {
          resolve({ status: 'completed', data: result });
        });
      });
    }

    // Start new report generation
    this.queue.set(key, true);
    try {
      logger.info(`Generating new report: ${key}`);
      const result = await generateReportFn();

      try {
        await cachingService.setWithTTL(key, JSON.stringify(result), 300); // Cache for 5 minutes
        logger.info(`Cached report result: ${key}`);
      } catch (cacheError) {
        logger.warn(`Error caching report result: ${cacheError.message}`);
      }

      this.emit(`report-${key}`, result);
      return { status: 'completed', data: result };
    } catch (error) {
      logger.error(`Error generating report: ${error.message}`);
      return { status: 'error', message: 'An error occurred while generating the report.' };
    } finally {
      this.queue.delete(key);
    }
  }
};
