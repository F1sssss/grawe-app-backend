const { get, setWithTTL } = require('../services/cachingService');
const logger = require('../logging/winstonSetup');

module.exports = cacheQuery = async (cacheKey, promiseQuery) => {
  try {
    logger.debug('cacheQuery: cacheQuery called with cacheKey: ', cacheKey);

    const cacheData = await get(cacheKey);

    if (cacheData) {
      logger.debug('cacheQuery: cacheData found for cacheKey: ', cacheKey);
      return { ...cacheData, statusCode: 200 };
    }
    const data = await promiseQuery;

    logger.debug('cacheQuery: cacheData not found for cacheKey: ', cacheKey);
    logger.debug('cacheQuery: Setting cache for cacheKey: ', cacheKey);

    await setWithTTL(cacheKey, JSON.stringify({ ...data }));

    return { ...data, statusCode: 200 };
  } catch (error) {
    throw error;
  }
};
