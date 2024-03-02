const winston = require('winston');
const LogstashTransport = require('winston-logstash-transport').LogstashTransport;
const { ElasticsearchTransport } = require('winston-elasticsearch');
const ecsFormat = require('@elastic/ecs-winston-format');

const esTransportOpts = {
  level: 'info',
  clientOpts: { node: 'http://elasticsearch:9200/' },
};

const esTransport = new ElasticsearchTransport(esTransportOpts);

const logger = winston.createLogger({
  level: 'info',
  transports: [
    new winston.transports.Console(),
    new winston.transports.File({ filename: 'logs/combined.log' }),
    new LogstashTransport({ host: 'localhost', port: 50000 }),
    esTransport,
  ],
});

logger.format = ecsFormat({ convertReqRes: true });

logger.add(new winston.transports.File({ filename: 'error.log', level: 'error' }));

module.exports = logger;
