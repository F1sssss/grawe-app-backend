const { get, setWithTTL } = require('../services/cachingService');
const logger = require('../logging/winstonSetup');

module.exports = cacheQuery = async (cacheKey, promiseQuery) => {
  logger.debug('cacheQuery: cacheQuery called with cacheKey: ', cacheKey, ' and promiseQuery: ', promiseQuery);

  const cacheData = await get(cacheKey);

  if (cacheData) {
    return { ...cacheData, statusCode: 200 };
  }
  const data = await promiseQuery;

  await setWithTTL(cacheKey, JSON.stringify({ ...data }));

  return { ...data, statusCode: 200 };
};
