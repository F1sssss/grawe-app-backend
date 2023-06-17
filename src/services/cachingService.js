const redis = require('redis');

const AppError = require('../utils/appError');

const client = redis.createClient({
  socket: {
    port: 6379,
    host: process.env.REDIS_HOST
  },
  password: process.env.REDIS_PASSWORD
});

(async () => {
  try {
    await client.connect();
  } catch (err) {
    throw new AppError('Could not connect to Redis', 500, 'error-connecting-to-redis-server');
  }
})();

client.on('error', (error) => {
  throw new AppError(error, 500, 'unhandled-redis-error');
});

client.on('connect', () => {
  console.log('💰 Connected to Redis server');
});

async function setWithTTL(key, value, ttl = 6000) {
  try {
    const result = await client.set(key, value);
    await client.expire(key, ttl);
    return result;
  } catch (err) {
    throw new AppError('Could not set value in Redis', 500, 'error-setting-value-in-redis');
  }
}

async function get(key) {
  try {
    return JSON.parse(await client.get(key));
  } catch (err) {
    throw new AppError('Could not get value from Redis', 500, 'error-getting-value-from-redis');
  }
}

module.exports = {
  setWithTTL,
  get
};
