const dashboardService = require('../services/dashboardService');
const CatchAsync = require('../utils/../middlewares/CatchAsync');
const ResponseHandler = require('../utils/ResponseHandler');

const getDashboard = CatchAsync(async (req, res, next) => {
  await ResponseHandler(dashboardService.getDashboardService(req.params.id), res, { statusCode: 200 });
});

module.exports = {
  getDashboard,
};
