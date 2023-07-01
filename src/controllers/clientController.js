const clientService = require('../services/clientService');
const responseHandler = require('../utils/responseHandler');
const CatchAsync = require('../utils/CatchAsync');

const getClientHistory = CatchAsync(async (req, res) => {
  await responseHandler(
    clientService.getClientHistoryService(req.params.id, req.query.dateFrom, req.query.dateTo),
    res,
    { statusCode: 200 },
    'success',
  );
});

const getClientInfo = CatchAsync(async (req, res) => {
  await responseHandler(clientService.getClientInfoService(req.params.id), res, { statusCode: 200 }, 'success');
});

const getClientAnalyticalInfo = CatchAsync(async (req, res) => {
  await responseHandler(
    clientService.getClientAnalyticalInfoService(req.params.id, req.query.dateFrom, req.query.dateTo),
    res,
    { statusCode: 200 },
    'success',
  );
});

module.exports = {
  getClientHistory,
  getClientInfo,
  getClientAnalyticalInfo,
};
