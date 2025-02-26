const os = require('os');
const logger = require('../logging/winstonSetup');

class PerformanceMonitor {
  constructor(options = {}) {
    this.enabled = options.enabled !== false;
    this.interval = options.interval || 5 * 60 * 1000; // Default: 5 minutes
    this.timer = null;
    this.startTime = Date.now();
    this.lastSnapshotTime = this.startTime;
    this.requestCounts = {
      total: 0,
      success: 0,
      error: 0,
      warn: 0,
    };
    this.responseTimes = [];
    this.dbQueryTimes = [];
  }

  start() {
    if (!this.enabled) return;

    this.logSystemInfo();

    this.timer = setInterval(() => {
      this.logPerformanceMetrics();
    }, this.interval);

    logger.info('Performance monitoring started', {
      type: 'performance-monitor',
      action: 'start',
      interval: this.interval,
    });
  }

  stop() {
    if (this.timer) {
      clearInterval(this.timer);
      this.timer = null;
      logger.info('Performance monitoring stopped', {
        type: 'performance-monitor',
        action: 'stop',
      });
    }
  }

  logSystemInfo() {
    const systemInfo = {
      type: 'system-info',
      hostname: os.hostname(),
      platform: process.platform,
      arch: process.arch,
      nodeVersion: process.version,
      cpus: os.cpus().length,
      totalMemory: Math.round((os.totalmem() / (1024 * 1024 * 1024)) * 100) / 100 + ' GB',
      uptime: Math.round(os.uptime() / 60) + ' minutes',
    };

    logger.info('System information', systemInfo);
  }

  recordRequest(responseTime, statusCode) {
    if (!this.enabled) return;

    this.requestCounts.total++;

    if (statusCode >= 500) {
      this.requestCounts.error++;
    } else if (statusCode >= 400) {
      this.requestCounts.warn++;
    } else {
      this.requestCounts.success++;
    }

    this.responseTimes.push(responseTime);

    // Keep array size reasonable
    if (this.responseTimes.length > 1000) {
      this.responseTimes.shift();
    }
  }

  recordDbQuery(queryTime) {
    if (!this.enabled) return;

    this.dbQueryTimes.push(queryTime);

    // Keep array size reasonable
    if (this.dbQueryTimes.length > 1000) {
      this.dbQueryTimes.shift();
    }
  }

  calculateStats(times) {
    if (!times.length) {
      return {
        count: 0,
        min: 0,
        max: 0,
        avg: 0,
        p95: 0,
      };
    }

    const sortedTimes = [...times].sort((a, b) => a - b);

    return {
      count: times.length,
      min: sortedTimes[0],
      max: sortedTimes[sortedTimes.length - 1],
      avg: Math.round(sortedTimes.reduce((sum, time) => sum + time, 0) / sortedTimes.length),
      p95: sortedTimes[Math.floor(sortedTimes.length * 0.95)],
    };
  }

  logPerformanceMetrics() {
    const now = Date.now();
    const uptimeMs = now - this.startTime;
    const intervalMs = now - this.lastSnapshotTime;
    this.lastSnapshotTime = now;

    // Calculate memory usage
    const memoryUsage = process.memoryUsage();

    // Calculate response time statistics
    const responseTimeStats = this.calculateStats(this.responseTimes);

    // Calculate DB query time statistics
    const dbQueryTimeStats = this.calculateStats(this.dbQueryTimes);

    // Calculate requests per second
    const requestsPerSecond = this.requestCounts.total / (uptimeMs / 1000);

    // Log metrics
    logger.info('Performance metrics', {
      type: 'performance-metrics',
      timestamp: new Date().toISOString(),
      uptimeSeconds: Math.round(uptimeMs / 1000),
      intervalSeconds: Math.round(intervalMs / 1000),
      memory: {
        rss: Math.round(memoryUsage.rss / (1024 * 1024)) + ' MB',
        heapTotal: Math.round(memoryUsage.heapTotal / (1024 * 1024)) + ' MB',
        heapUsed: Math.round(memoryUsage.heapUsed / (1024 * 1024)) + ' MB',
        external: Math.round(memoryUsage.external / (1024 * 1024)) + ' MB',
      },
      requests: {
        total: this.requestCounts.total,
        success: this.requestCounts.success,
        warn: this.requestCounts.warn,
        error: this.requestCounts.error,
        successRate: this.requestCounts.total ? ((this.requestCounts.success / this.requestCounts.total) * 100).toFixed(2) + '%' : '0%',
        requestsPerSecond: requestsPerSecond.toFixed(2),
      },
      responseTimes: responseTimeStats,
      dbQueryTimes: dbQueryTimeStats,
      load: os.loadavg(),
    });

    // Reset counters for next interval
    this.responseTimes = [];
    this.dbQueryTimes = [];
  }
}

// Create singleton instance
const performanceMonitor = new PerformanceMonitor({
  enabled: process.env.NODE_ENV !== 'test',
  interval: 5 * 60 * 1000, // 5 minutes
});

module.exports = performanceMonitor;
