const redis = require('redis');
const AppError = require('../../utils/AppError');
const logger = require('../../logging/winstonSetup');
const redisServices = require('./../../services/cachingService');

jest.mock('redis');
jest.mock('../../utils/AppError');
jest.mock('../../logging/winstonSetup');

let client = redis.createClient({
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

describe('Redis Services', () => {
  let mockRedisClient;

  beforeAll(async () => {
    mockRedisClient = {
      connect: jest.fn(),
      set: jest.fn(),
      expire: jest.fn(),
      get: jest.fn(),
      flushAll: jest.fn(),
      del: jest.fn(),
      on: jest.fn(),
    };

    redis.createClient.mockReturnValue(mockRedisClient);
  });

  afterEach(() => {
    jest.clearAllMocks();
  });

  describe('setWithTTL', () => {
    it('should set a value with TTL successfully', async () => {
      mockRedisClient.set.mockResolvedValue('OK');
      mockRedisClient.expire.mockResolvedValue(1);

      const result = await redisServices.setWithTTL('testKey', 'testValue', 3600);

      expect(mockRedisClient.set).toHaveBeenCalledWith('testKey', 'testValue');
      expect(mockRedisClient.expire).toHaveBeenCalledWith('testKey', 3600);
      expect(result).toBe('OK');
      expect(logger.info).toHaveBeenCalledWith('Set value in Redis for key: testKey');
    });

    it('should throw an AppError when setting fails', async () => {
      mockRedisClient.set.mockRejectedValue(new Error('Redis error'));

      await expect(redisServices.setWithTTL('testKey', 'testValue')).rejects.toThrow(AppError);
      expect(logger.error).toHaveBeenCalled();
    });
  });

  describe('get', () => {
    it('should get a value successfully', async () => {
      const mockValue = JSON.stringify({ foo: 'bar' });
      mockRedisClient.get.mockResolvedValue(mockValue);

      const result = await redisServices.get('testKey');

      expect(mockRedisClient.get).toHaveBeenCalledWith('testKey');
      expect(result).toEqual({ foo: 'bar' });
      expect(logger.info).toHaveBeenCalledWith('Getting value from Redis for key: testKey');
    });

    it('should throw an AppError when getting fails', async () => {
      mockRedisClient.get.mockRejectedValue(new Error('Redis error'));

      await expect(redisServices.get('testKey')).rejects.toThrow(AppError);
      expect(logger.error).toHaveBeenCalled();
    });
  });

  describe('del', () => {
    it('should delete all keys successfully', async () => {
      const mockNext = jest.fn();
      await redisServices.del({}, {}, mockNext);

      expect(mockRedisClient.flushAll).toHaveBeenCalled();
      expect(logger.info).toHaveBeenCalledWith('Deleted all keys from Redis');
      expect(mockNext).toHaveBeenCalled();
    });

    it('should throw an AppError when deletion fails', async () => {
      mockRedisClient.flushAll.mockRejectedValue(new Error('Redis error'));

      await expect(redisServices.del({}, {}, jest.fn())).rejects.toThrow(AppError);
      expect(logger.error).toHaveBeenCalled();
    });
  });

  describe('delKey', () => {
    it('should delete a specific key successfully', async () => {
      await redisServices.delKey('testKey');

      expect(mockRedisClient.del).toHaveBeenCalledWith('testKey');
      expect(logger.info).toHaveBeenCalledWith('💰 Redis key deleted: ', 'testKey');
    });

    it('should throw an AppError when key deletion fails', async () => {
      mockRedisClient.del.mockRejectedValue(new Error('Redis error'));

      await expect(redisServices.delKey('testKey')).rejects.toThrow(AppError);
      expect(logger.error).toHaveBeenCalled();
    });

    it('should not throw an error if the key does not exist', async () => {
      mockRedisClient.del.mockResolvedValue(0); // 0 indicates no key was deleted

      await expect(redisServices.delKey('nonExistentKey')).resolves.not.toThrow();
      expect(logger.info).toHaveBeenCalledWith('💰 Redis key deleted: ', 'nonExistentKey');
    });
  });
});
