const { get, setWithTTL } = require('../services/cachingService');

module.exports = cacheQuery = async (cacheKey, promiseQuery) => {
  const cacheData = await get(cacheKey);

  if (cacheData) {
    return { ...cacheData, statusCode: 200 };
  }
  const data = await promiseQuery;

  await setWithTTL(cacheKey, JSON.stringify({ ...data }));

  return { ...data, statusCode: 200 };
};
