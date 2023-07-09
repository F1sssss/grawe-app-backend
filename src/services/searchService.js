const cacheQuery = require('../utils/cacheQuery');
const SearchQueries = require('../sql/Queries/searchQueries');

const searchAllService = async () => {
  const cacheKey = `search-all`;
  const { searchResult, statusCode } = await cacheQuery(cacheKey, SearchQueries.searchAll());
  return { searchResult, statusCode };
};

module.exports = {
  searchAllService,
};
