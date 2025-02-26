const redis = require('redis');
const AppError = require('../utils/AppError');
const logger = require('../logging/winstonSetup');
const config = require('../config/config');

let client;

function createClient() {
  if (client) return client;

  client = redis.createClient({
    socket: {
      port: config.redis.port,
      host: config.redis.host,
      reconnectStrategy: (retries) => {
        if (retries > 10) {
          logger.error('Max Redis reconnection attempts reached');
          return new AppError('Max Redis reconnection attempts reached', 500);
        }
        return Math.min(retries * 100, 3000);
      },
    },
    password: config.redis.password,
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
  // Skip Redis connection if Redis is not enabled
  if (!config.redis.enabled) {
    logger.info('Redis is disabled, skipping connection');
    return;
  }

  try {
    const redisClient = createClient();
    await redisClient.connect();
  } catch (err) {
    // In development, we can continue without Redis
    if (config.isDevelopment) {
      logger.warn(`Could not connect to Redis server: ${err}. Continuing without caching.`);
    } else {
      // In production, Redis is required
      logger.error(`Could not connect to Redis server: ${err}`);
      throw err;
    }
  }
}

async function setWithTTL(key, value, ttl = 6000) {
  // Skip if Redis is disabled
  if (!config.redis.enabled) return;

  const redisClient = createClient();
  try {
    if (!redisClient.isReady) {
      logger.warn('Redis client not ready. Skipping cache set.');
      return;
    }

    await redisClient.set(key, value);
    await redisClient.expire(key, ttl);
    logger.info(`Set value in Redis for key: ${key}`);
  } catch (err) {
    logger.error(`Could not set value in Redis: ${err}`);
  }
}

async function get(key) {
  // Skip if Redis is disabled
  if (!config.redis.enabled) return null;

  const redisClient = createClient();
  try {
    if (!redisClient.isReady) {
      logger.warn('Redis client not ready. Skipping cache get.');
      return null;
    }

    logger.info(`Getting value from Redis for key: ${key}`);
    const value = await redisClient.get(key);
    return value ? JSON.parse(value) : null;
  } catch (err) {
    logger.error(`Could not get value from Redis: ${err}`);
    return null;
  }
}

async function del(req, res, next) {
  // Skip if Redis is disabled
  if (!config.redis.enabled) {
    if (next) next();
    return;
  }

  const redisClient = createClient();
  try {
    if (!redisClient.isReady) {
      logger.warn('Redis client not ready. Skipping cache flush.');
      if (next) next();
      return;
    }

    await redisClient.flushAll();
    logger.info('Deleted all keys from Redis');
    if (next) next();
  } catch (err) {
    logger.error(`Could not delete value from Redis: ${err}`);
    if (next) next();
  }
}

async function delKey(key) {
  // Skip if Redis is disabled
  if (!config.redis.enabled) return;

  const redisClient = createClient();
  try {
    if (!redisClient.isReady) {
      logger.warn('Redis client not ready. Skipping cache key deletion.');
      return;
    }

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
