const cacheQuery = require('../utils/cacheQuery');
const ClientQueries = require('../sql/Queries/ClientQueries');

const getClientHistoryService = async (id, dateFrom, dateTo) => {
  const cacheKey = `client-history-${id}-${dateFrom}-${dateTo}`;
  return ({ client, statusCode } = await cacheQuery(cacheKey, ClientQueries.getClientHistory(id)));
};

const getClientInfoService = async (id) => {
  const cacheKey = `client-info-${id}`;
  return ({ client, statusCode } = await cacheQuery(cacheKey, ClientQueries.getClientInfo(id)));
};

const getClientAnalyticalInfoService = async (id, dateFrom, dateTo) => {
  const cacheKey = `client-analytics-${id}-${dateFrom}-${dateTo}`;
  return ({ client, statusCode } = await cacheQuery(cacheKey, ClientQueries.getClientAnalyticalInfo(id)));
};

module.exports = {
  getClientHistoryService,
  getClientInfoService,
  getClientAnalyticalInfoService,
};
