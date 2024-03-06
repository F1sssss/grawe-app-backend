const winston = require('winston');
const ecsFormat = require('@elastic/ecs-winston-format');

const logger = winston.createLogger({
  level: 'debug',
  transports: [
    //new winston.transports.Console(),
    new winston.transports.File({ filename: 'logs/combined.log' }),
  ],
});

logger.format = ecsFormat({ convertReqRes: true });

logger.add(new winston.transports.File({ filename: 'logs/error.log', level: 'error' }));

module.exports = logger;
