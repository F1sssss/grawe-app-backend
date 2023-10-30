//Controller for client information and analytics

//TODO: Better naming for this controller
const clientService = require('../services/clientService');
const handleResponse = require('../utils/responseHandler');
const CatchAsync = require('../utils/CatchAsync');

const getClientHistory = CatchAsync(async (req, res) => {
  await handleResponse(
    clientService.getClientHistoryService(req.params.id, req.query.dateFrom, req.query.dateTo),
    res,
    { statusCode: 200 },
    'success',
  );
});

const getClientInfo = CatchAsync(async (req, res) => {
  await handleResponse(clientService.getClientInfoService(req.params.id), res, { statusCode: 200 }, 'success');
});

const getClientAnalyticalInfo = CatchAsync(async (req, res) => {
  await handleResponse(
    clientService.getClientAnalyticalInfoService(req.params.id, req.query.dateFrom, req.query.dateTo),
    res,
    { statusCode: 200 },
    'success',
  );
});

const getClientPolicyAnalyticalInfo = CatchAsync(async (req, res) => {
  await handleResponse(
    clientService.getClientPolicyAnalyticalInfoService(req.params.id, req.query.dateFrom, req.query.dateTo),
    res,
    { statusCode: 200 },
    'success',
  );
});

const getAllClientAnalytics = CatchAsync(async (req, res) => {
  await handleResponse(
    clientService.getAllClientAnalyticsService(req.params.id, req.query.dateFrom, req.query.dateTo),
    res,
    { statusCode: 200 },
    'success',
  );
});

//TOBE DELETED
const getAllClientInfo = CatchAsync(async (req, res) => {
  await handleResponse(
    clientService.getAllClientInfoService(req.params.id, req.query.dateFrom, req.query.dateTo),
    res,
    { statusCode: 200 },
    'success',
  );
});

const getClientHistoryExcelDownload = CatchAsync(async (req, res) => {
  const { excelBuffer } = await clientService.getClientHistoryExcelDownloadService(res, req.params.id, req.query.dateFrom, req.query.dateTo);
  res.status(200).send(excelBuffer);
});

const getClientHistoryPDFDownload = CatchAsync(async (req, res) => {
  const { pdfBuffer } = await clientService.getPolicyHistoryPDFDownloadService(res, req.params.id, req.query.dateFrom, req.query.dateTo);
  res.status(200).send(pdfBuffer);
});

module.exports = {
  getClientHistory,
  getClientInfo,
  getClientAnalyticalInfo,
  getClientHistoryExcelDownload,
  getClientHistoryPDFDownload,
  getAllClientAnalytics,
  getAllClientInfo,
  getClientPolicyAnalyticalInfo,
};
