const searchQueries = require('../sql/Queries/searchQueries');
const catchAsync = require('../utils/catchAsync');
const handleResponse = require('../utils/responseHandler');

const globalSearchController = catchAsync(async (req, res) => {
  await handleResponse(searchQueries.searchQueries(req.query.search), res, { statusCode: 201 }, 'success!');
});

module.exports = {
  globalSearchController,
};
