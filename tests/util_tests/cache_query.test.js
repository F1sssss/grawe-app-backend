const cacheQuery = require('../../src/utils/cacheQuery');
const { get, setWithTTL } = require('../../src/services/cachingService');
const logger = require('../../src/logging/winstonSetup');
const AppError = require('../../src/utils/AppError');

jest.mock('../../src/services/cachingService');
jest.mock('../../src/logging/winstonSetup');

describe('cacheQuery', () => {
  beforeEach(() => {
    jest.clearAllMocks();
  });

  it('should return cached data if available', async () => {
    const cacheKey = 'testKey';
    const cachedData = { foo: 'bar' };
    get.mockResolvedValue(cachedData);

    const result = await cacheQuery(cacheKey, jest.fn());

    expect(result).toEqual({ ...cachedData, statusCode: 200 });
    expect(get).toHaveBeenCalledWith(cacheKey);
    expect(logger.debug).toHaveBeenCalledWith('cacheQuery: cacheData found for cacheKey: ', cacheKey);
  });

  it('should fetch and cache new data if not in cache', async () => {
    const cacheKey = 'testKey';
    const fetchedData = { foo: 'baz' };
    get.mockResolvedValue(null);
    const mockPromiseQuery = jest.fn().mockResolvedValue(fetchedData);

    mockPromiseQuery.mockResolvedValue(fetchedData);
    const data = await cacheQuery(cacheKey, mockPromiseQuery);
    expect(get).toHaveBeenCalledWith(cacheKey);
  });

  it('should throw an error if fetching data fails', async () => {
    const cacheKey = 'testKey';
    const error = new Error('Fetch failed');
    get.mockResolvedValue(null);
    const mockPromiseQuery = jest.fn().mockRejectedValue(error);

    try {
      await cacheQuery(cacheKey, mockPromiseQuery);
    } catch (e) {
      expect(e).toBeInstanceOf(AppError);
    }
  });
});
