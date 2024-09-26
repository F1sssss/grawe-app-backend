const { get, setWithTTL } = require('../services/cachingService');
const logger = require('../logging/winstonSetup');

module.exports = cacheQuery = async (cacheKey, promiseQuery) => {
  try {
    const cacheData = await get(cacheKey);

    if (cacheData) {
      logger.debug('cacheQuery: cacheData found for cacheKey: ', cacheKey);
      return { ...cacheData, statusCode: 200 };
    }
    const data = await promiseQuery;

    await setWithTTL(cacheKey, JSON.stringify({ ...data }));

    return { ...data, statusCode: 200 };
  } catch (error) {
    throw error;
  }
};
