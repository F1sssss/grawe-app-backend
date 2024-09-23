// cachingService.js
const redis = require('redis');
const AppError = require('../utils/AppError');
const logger = require('../logging/winstonSetup');

let client;

function createClient() {
  if (client) return client;

  client = redis.createClient({
    socket: {
      port: 6379,
      host: process.env.REDIS_HOST,
      reconnectStrategy: function (times, cause) {
        logger.error(`Could not connect to Redis server: ${cause}`);
        console.log(cause);
        if (times >= 3) {
          throw new AppError('Could not connect to Redis', 500, 'error-connecting-to-redis-server');
        }
      },
    },
    password: process.env.REDIS_PASSWORD,
    AutoReconnect: true,
    KeepAlive: 1000,
  });

  client.on('error', (error) => {
    logger.error(`Could not connect to Redis server: ${error}`);
    console.log(error);
    throw new AppError(error, 500, 'unhandled-redis-error');
  });

  client.on('connect', () => {
    console.log('💰 Connected to Redis server');
    logger.info('Connected to Redis server');
  });

  return client;
}

async function connectToRedis() {
  try {
    const redisClient = createClient();
    await redisClient.connect();
  } catch (err) {
    logger.error(`Could not connect to Redis server: ${err}`);
    throw new AppError('Could not connect to Redis', 500, 'error-connecting-to-redis-server');
  }
}

async function setWithTTL(key, value, ttl = 6000) {
  const redisClient = createClient();
  try {
    const result = await redisClient.set(key, value);
    await redisClient.expire(key, ttl);
    logger.info(`Set value in Redis for key: ${key}`);
    return result;
  } catch (err) {
    logger.error(`Could not set value in Redis: ${err}`);
    throw new AppError('Could not set value in Redis', 500, 'error-setting-value-in-redis');
  }
}

async function get(key) {
  const redisClient = createClient();
  try {
    logger.info(`Getting value from Redis for key: ${key}`);
    return JSON.parse(await redisClient.get(key));
  } catch (err) {
    logger.error(`Could not get value from Redis: ${err}`);
    throw new AppError('Could not get value from Redis', 500, 'error-getting-value-from-redis');
  }
}

async function del(req, res, next) {
  const redisClient = createClient();
  try {
    await redisClient.flushAll();
    logger.info('Deleted all keys from Redis');
    next();
  } catch (err) {
    logger.error(`Could not delete value from Redis: ${err}`);
    throw new AppError('Could not delete value from Redis', 500, 'error-deleting-value-from-redis');
  }
}

async function delKey(key) {
  const redisClient = createClient();
  try {
    await redisClient.del(key);
    logger.info('💰 Redis key deleted: ', key);
  } catch (err) {
    logger.error(`Could not delete value from Redis: ${err}`);
    throw new AppError('Could not delete value from Redis', 500, 'error-deleting-value-from-redis');
  }
}

module.exports = {
  createClient,
  connectToRedis,
  setWithTTL,
  get,
  del,
  delKey,
};
