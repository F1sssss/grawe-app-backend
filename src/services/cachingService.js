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
      reconnectStrategy: (retries) => {
        if (retries > 10) {
          logger.error('Max Redis reconnection attempts reached');
          return new AppError('Max Redis reconnection attempts reached', 500);
        }
        return Math.min(retries * 100, 3000);
      },
    },
    password: process.env.REDIS_PASSWORD,
  });

  client.on('error', (error) => {
    logger.error(`Redis error: ${error}`);
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
  }
}

async function setWithTTL(key, value, ttl = 6000) {
  const redisClient = createClient();
  try {
    await redisClient.set(key, value);
    await redisClient.expire(key, ttl);
    logger.info(`Set value in Redis for key: ${key}`);
  } catch (err) {
    logger.error(`Could not set value in Redis: ${err}`);
  }
}

async function get(key) {
  const redisClient = createClient();
  try {
    logger.info(`Getting value from Redis for key: ${key}`);
    const value = await redisClient.get(key);
    return value ? JSON.parse(value) : null;
  } catch (err) {
    logger.error(`Could not get value from Redis: ${err}`);
    return null;
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
  }
}

async function delKey(key) {
  const redisClient = createClient();
  try {
    await redisClient.del(key);
    logger.info('Redis key deleted: ', key);
  } catch (err) {
    logger.error(`Could not delete value from Redis: ${err}`);
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
