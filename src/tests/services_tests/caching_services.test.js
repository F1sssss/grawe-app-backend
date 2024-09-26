// caching_services.test.js
const redis = require('redis');
const AppError = require('../../utils/AppError');
const logger = require('../../logging/winstonSetup');
const cachingService = require('../../services/cachingService');

jest.mock('redis');
jest.mock('../../utils/AppError');
jest.mock('../../logging/winstonSetup');

describe('Caching Service', () => {
  let mockRedisClient;

  beforeAll(() => {
    // Mocking Redis client methods
    mockRedisClient = {
      connect: jest.fn(),
      set: jest.fn(),
      get: jest.fn(),
      expire: jest.fn(),
      flushAll: jest.fn(),
      del: jest.fn(),
      on: jest.fn(),
    };

    redis.createClient.mockReturnValue(mockRedisClient);
  });

  beforeEach(() => {
    jest.clearAllMocks();
  });

  describe('createClient', () => {
    it('should create and return a new Redis client', () => {
      const client = cachingService.createClient();
      expect(redis.createClient).toHaveBeenCalled();
      expect(client).toBe(mockRedisClient);
    });
  });

  describe('connectToRedis', () => {
    it('should connect to Redis server successfully', async () => {
      await cachingService.connectToRedis();
      expect(mockRedisClient.connect).toHaveBeenCalled();
    });

    it('should throw AppError if connection fails', async () => {
      mockRedisClient.connect.mockRejectedValue(new Error('Connection failed'));
      try {
        await cachingService.connectToRedis();
      } catch (e) {
        expect(e).toBeInstanceOf(AppError);
      }
    });
  });

  describe('setWithTTL', () => {
    it('should set a key with a TTL in Redis', async () => {
      mockRedisClient.set.mockResolvedValue('OK');
      mockRedisClient.expire.mockResolvedValue();

      await cachingService.setWithTTL('testKey', 'testValue', 6000);

      expect(mockRedisClient.set).toHaveBeenCalledWith('testKey', 'testValue');
      expect(mockRedisClient.expire).toHaveBeenCalledWith('testKey', 6000);
      expect(logger.info).toHaveBeenCalledWith(expect.stringContaining('Set value in Redis for key: testKey'));
    });

    it('should throw AppError if setting the key fails', async () => {
      mockRedisClient.set.mockRejectedValue(new Error('Set failed'));
      try {
        await cachingService.setWithTTL('testKey', 'testValue');
      } catch (e) {
        expect(e).toBeInstanceOf(AppError);
      }
    });
  });

  describe('get', () => {
    it('should get a value from Redis by key', async () => {
      const mockValue = JSON.stringify({ key: 'value' });
      mockRedisClient.get.mockResolvedValue(mockValue);

      const result = await cachingService.get('testKey');

      expect(mockRedisClient.get).toHaveBeenCalledWith('testKey');
      expect(logger.info).toHaveBeenCalledWith(expect.stringContaining('Getting value from Redis for key: testKey'));
      expect(result).toEqual({ key: 'value' });
    });

    it('should throw AppError if getting the value fails', async () => {
      mockRedisClient.get.mockRejectedValue(new Error('Get failed'));
      try {
        await cachingService.get('testKey');
      } catch (e) {
        expect(e).toBeInstanceOf(AppError);
      }
    });
  });

  describe('del', () => {
    it('should flush all keys in Redis', async () => {
      const req = {};
      const res = {};
      const next = jest.fn();

      mockRedisClient.flushAll.mockResolvedValue();

      await cachingService.del(req, res, next);

      expect(mockRedisClient.flushAll).toHaveBeenCalled();
      expect(logger.info).toHaveBeenCalledWith('Deleted all keys from Redis');
      expect(next).toHaveBeenCalled();
    });

    it('should throw AppError if flushing all keys fails', async () => {
      const req = {};
      const res = {};
      const next = jest.fn();
      mockRedisClient.flushAll.mockRejectedValue(new Error('Flush failed'));
      try {
        await cachingService.del(req, res, next);
      } catch (e) {
        expect(e).toBeInstanceOf(AppError);
      }
    });
  });

  describe('delKey', () => {
    it('should delete a key from Redis', async () => {
      mockRedisClient.del.mockResolvedValue(1);

      await cachingService.delKey('testKey');

      expect(mockRedisClient.del).toHaveBeenCalledWith('testKey');
    });

    it('should throw AppError if deleting the key fails', async () => {
      mockRedisClient.del.mockRejectedValue(new Error('Delete failed'));
      try {
        await cachingService.delKey('testKey');
      } catch (e) {
        expect(e).toBeInstanceOf(AppError);
      }
    });
  });
});
