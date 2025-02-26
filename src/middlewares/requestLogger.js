const { v4: uuidv4 } = require('uuid');
const logger = require('../logging/winstonSetup');
const { getUserContext } = require('./userContext');

const requestLogger = (req, res, next) => {
  req.id = uuidv4();

  const startTime = Date.now();

  const method = req.method;
  const url = req.originalUrl || req.url;
  const ip = req.headers['x-forwarded-for'] || req.connection.remoteAddress;
  const userAgent = req.headers['user-agent'];

  const userContext = getUserContext();
  const userId = userContext ? userContext.userId : 'unknown';

  logger.info(`Incoming request: ${method} ${url}`, {
    type: 'request-start',
    requestId: req.id,
    userId,
    method,
    url,
    ip,
    userAgent,
    query: req.query,
    params: req.params,
  });

  res.on('finish', () => {
    const duration = Date.now() - startTime;
    const status = res.statusCode;

    logger.logRequest(req, status, duration);

    if (status >= 400) {
      logger.warn(`Request failed: ${method} ${url} ${status}`, {
        type: 'request-error',
        requestId: req.id,
        userId,
        status,
        duration,
        method,
        url,
      });
    }
  });

  next();
};

module.exports = requestLogger;
