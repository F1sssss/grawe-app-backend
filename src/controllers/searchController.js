//Global search controller

const searchQueries = require('../sql/Queries/searchQueries');
const catchAsync = require('../middlewares/CatchAsync');
const handleResponse = require('../utils/responseHandler');
const { searchAllService } = require('../services/searchService');

const globalSearchController = catchAsync(async (req, res) => {
  await handleResponse(searchQueries.search(req.query.search), res, { statusCode: 201 });
});

const searchAllController = catchAsync(async (req, res) => {
  await handleResponse(searchAllService(), res, { statusCode: 201 });
});

module.exports = {
  globalSearchController,
  searchAllController,
};
