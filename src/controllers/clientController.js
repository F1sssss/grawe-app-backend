const clientService = require('../services/clientService');
const handleResponse = require('../utils/responseHandler');
const CatchAsync = require('../middlewares/CatchAsync');

const getClientHistory = CatchAsync(async (req, res) => {
  await handleResponse(clientService.getClientHistoryService(req.params.id, req.query.dateFrom, req.query.dateTo), res);
});

const getClientInfo = CatchAsync(async (req, res) => {
  await handleResponse(clientService.getClientInfoService(req.params.id), res);
});

const getClientAnalyticalInfo = CatchAsync(async (req, res) => {
  await handleResponse(clientService.getClientAnalyticalInfoService(req.params.id, req.query.dateFrom, req.query.dateTo), res);
});

const getClientPolicyAnalyticalInfo = CatchAsync(async (req, res) => {
  await handleResponse(clientService.getClientPolicyAnalyticalInfoService(req.params.id, req.query.dateFrom, req.query.dateTo), res);
});

const getAllClientAnalytics = CatchAsync(async (req, res) => {
  await handleResponse(clientService.getAllClientAnalyticsService(req.params.id, req.query.dateFrom, req.query.dateTo), res);
});

//TOBE DELETED
const getAllClientInfo = CatchAsync(async (req, res) => {
  await handleResponse(clientService.getAllClientInfoService(req.params.id, req.query.dateFrom, req.query.dateTo), res);
});

const getClientHistoryExcelDownload = CatchAsync(async (req, res) => {
  const { excelBuffer } = await clientService.getClientHistoryExcelDownloadService(res, req.params.id, req.query.dateFrom, req.query.dateTo);
  res.status(200).send(excelBuffer);
});

const getClientHistoryPDFDownload = CatchAsync(async (req, res) => {
  const { pdfBuffer } = await clientService.getPolicyHistoryPDFDownloadService(
    res,
    req.params.id,
    req.query.dateFrom,
    req.query.dateTo,
    req.query.ZK,
    req.query.AO,
  );
  res.status(200).send(pdfBuffer);
});

const getClientFinancialHistoryPDFDownload = CatchAsync(async (req, res) => {
  const { pdfBuffer } = await clientService.getClientFinancialHistoryPDFDownloadService(
    res,
    req.params.id,
    req.query.dateFrom,
    req.query.dateTo,
    req.query.ZK,
    req.query.AO,
  );
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
  getClientFinancialHistoryPDFDownload,
};
