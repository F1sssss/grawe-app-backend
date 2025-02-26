const winston = require('winston');
const path = require('path');
const { format } = winston;
const config = require('../config/config');

const logDir = path.join(process.cwd(), 'logs');

const consoleFormat = format.combine(
  format.timestamp({ format: 'YYYY-MM-DD HH:mm:ss' }),
  format.colorize(),
  format.printf(({ level, message, timestamp, ...meta }) => {
    const requestId = meta.requestId ? `[${meta.requestId}]` : '';
    const user = meta.userId ? `[User: ${meta.userId}]` : '';

    let log = `${timestamp} ${level}: ${requestId}${user} ${message}`;

    if (Object.keys(meta).length > 0 && !meta.requestId && !meta.userId) {
      log += ` ${JSON.stringify(meta)}`;
    }

    return log;
  }),
);

const elasticsearchFormat = format.combine(
  format.timestamp(),
  format.errors({ stack: true }),
  format.json(),
  format((info) => {
    info.environment = config.env;
    info.service = 'reporting-app';

    if (info.stack && !info.error) {
      info.error = {
        stack: info.stack,
        message: info.message,
      };
      delete info.stack;
    }

    return info;
  })(),
);

const logger = winston.createLogger({
  level: config.isDevelopment ? 'debug' : 'info',
  defaultMeta: { service: 'reporting-app' },
  transports: [
    // Console transport
    new winston.transports.Console({
      format: consoleFormat,
    }),

    new winston.transports.File({
      filename: path.join(logDir, 'combined.json'),
      format: elasticsearchFormat,
    }),

    new winston.transports.File({
      filename: path.join(logDir, 'combined.log'),
      format: format.combine(
        format.timestamp({ format: 'YYYY-MM-DD HH:mm:ss' }),
        format.printf(({ level, message, timestamp, ...meta }) => {
          const reqId = meta.requestId ? `[${meta.requestId}]` : '';
          const user = meta.userId ? `[User: ${meta.userId}]` : '';
          let log = `${timestamp} ${level}: ${reqId}${user} ${message}`;

          if (meta.error && meta.error.stack) {
            log += `\n${meta.error.stack}`;
          } else if (meta.stack) {
            log += `\n${meta.stack}`;
          }

          return log;
        }),
      ),
    }),

    new winston.transports.File({
      filename: path.join(logDir, 'error.log'),
      level: 'error',
      format: elasticsearchFormat,
    }),
  ],
  exceptionHandlers: [
    new winston.transports.File({
      filename: path.join(logDir, 'exceptions.log'),
      format: elasticsearchFormat,
    }),
  ],
  rejectionHandlers: [
    new winston.transports.File({
      filename: path.join(logDir, 'rejections.log'),
      format: elasticsearchFormat,
    }),
  ],
  exitOnError: false,
});

logger.logRequest = (req, status, responseTime) => {
  const userId = req.user ? req.user.ID : 'unauthenticated';
  const method = req.method;
  const url = req.originalUrl || req.url;
  const ip = req.headers['x-forwarded-for'] || req.connection.remoteAddress;
  const userAgent = req.headers['user-agent'];
  const referrer = req.headers.referer || req.headers.referrer;

  logger.info(`${method} ${url} ${status} ${responseTime}ms`, {
    type: 'request',
    requestId: req.id,
    userId,
    method,
    url,
    status,
    responseTime,
    ip,
    userAgent,
    referrer,
    query: req.query,
    params: req.params,
  });
};

logger.logQuery = (query, params, duration, status) => {
  logger.debug(`SQL Query executed in ${duration}ms`, {
    type: 'database',
    query: typeof query === 'string' ? query.slice(0, 500) : 'Stored procedure',
    params: JSON.stringify(params).slice(0, 200),
    duration,
    status,
  });
};

logger.child = (additionalMeta) => {
  return winston.createLogger({
    level: logger.level,
    defaultMeta: { ...logger.defaultMeta, ...additionalMeta },
    transports: logger.transports,
    exceptionHandlers: logger.exceptionHandlers,
    rejectionHandlers: logger.rejectionHandlers,
    exitOnError: logger.exitOnError,
  });
};

module.exports = logger;
