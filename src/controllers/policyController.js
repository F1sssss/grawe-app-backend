//Controller for policies routes
//TODO add policy route for analytical info
/** @namespace req.query.dateFrom * **/
/** @namespace req.query.dateTo * **/
const policyService = require('../services/policiesServices');
const CatchAsync = require('../utils/CatchAsync');
const handleResponse = require('../utils/responseHandler');

const getPolicyInfo = CatchAsync(async (req, res) => {
  await handleResponse(policyService.getPolicyInfoService(req.params.id), res, { statusCode: 200 }, 'success');
});

const getPolicyAnalyticalInfo = CatchAsync(async (req, res) => {
  await handleResponse(
    policyService.getPolicyAnalyticalInfoService(req.params.id, req.query.dateFrom, req.query.dateTo),
    res,
    { statusCode: 200 },
    'success',
  );
});

const getPolicyHistory = CatchAsync(async (req, res) => {
  await handleResponse(
    policyService.getPolicyHistoryService(req.params.id, req.query.dateFrom, req.query.dateTo),
    res,
    { statusCode: 200 },
    'success',
  );
});

const getAllPolicyAnalytics = CatchAsync(async (req, res) => {
  await handleResponse(
    policyService.getAllPolicyAnalyticsService(req.params.id, req.query.dateFrom, req.query.dateTo),
    res,
    { statusCode: 200 },
    'success',
  );
});

const getPolicyHistoryExcelDownload = CatchAsync(async (req, res) => {
  const { excelBuffer } = await policyService.getPolicyHistoryExcelDownloadService(res, req.params.id, req.query.dateFrom, req.query.dateTo);
  res.send(excelBuffer);
});

const getPolicyHistoryPDFDownload = CatchAsync(async (req, res) => {
  const { pdfBuffer, statusCode } = await policyService.getPolicyHistoryPDFDownloadService(res, req.params.id, req.query.dateFrom, req.query.dateTo);
  res.status(statusCode).send(pdfBuffer);
});

module.exports = {
  getPolicyHistory,
  getPolicyInfo,
  getPolicyHistoryExcelDownload,
  getPolicyHistoryPDFDownload,
  getPolicyAnalyticalInfo,
  getAllPolicyAnalytics,
};
