const winston = require('winston');
const ecsFormat = require('@elastic/ecs-winston-format');

const logger = winston.createLogger({
  level: 'debug',
  format: ecsFormat({ convertReqRes: true }),
  transports: [
    //new winston.transports.Console(),
    //new winston.transports.File({ filename: 'logs/combined.log' }),
    new winston.transports.File({ filename: 'logs/combined.json', level: 'debug' }),
  ],
});

logger.add(new winston.transports.File({ filename: 'logs/error.json', level: 'error' }));

logger.add(new winston.transports.File({ filename: 'logs/expressLogs.json', level: 'http' }));

module.exports = logger;
