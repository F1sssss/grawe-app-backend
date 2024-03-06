const redis = require('redis');

const AppError = require('../utils/AppError');
const logger = require('../logging/winstonSetup');

let client = redis.createClient({
  socket: {
    port: 6379,
    host: process.env.REDIS_HOST,
  },
  password: process.env.REDIS_PASSWORD,
  keepAlive: 500,
});

(async () => {
  try {
    await client.connect();
  } catch (err) {
    throw new AppError('Could not connect to Redis', 500, 'error-connecting-to-redis-server');
  }
})();

client.on('error', async (error) => {
  console.error('💰 Redis error: ', error);
});

client.on('connect', () => {
  console.log('💰 Connected to Redis server');
});

async function setWithTTL(key, value, ttl = 6000) {
  try {
    const result = await client.set(key, value);
    await client.expire(key, ttl);
    logger.info('💰 Redis set: ', key);
    return result;
  } catch (err) {
    throw new AppError('Could not set value in Redis', 500, 'error-setting-value-in-redis');
  }
}

async function get(key) {
  try {
    logger.info('💰 Redis get: ', key);
    return JSON.parse(await client.get(key));
  } catch (err) {
    logger.error('💰 Redis get error: ', err);
    throw new AppError('Could not get value from Redis', 500, 'error-getting-value-from-redis');
  }
}

async function del(req, res, next) {
  try {
    await client.flushAll();
    logger.info('💰 Redis flushed for all keys');
    next();
  } catch (err) {
    throw new AppError('Could not delete value from Redis', 500, 'error-deleting-value-from-redis');
  }
}

// I think this function will cause crash if the key does not exist, test!!!
async function delKey(key) {
  try {
    await client.del(key);
    logger.info('💰 Redis key deleted: ', key);
  } catch (err) {
    throw new AppError('Could not delete value from Redis', 500, 'error-deleting-value-from-redis');
  }
}

module.exports = {
  setWithTTL,
  get,
  del,
  delKey,
};
