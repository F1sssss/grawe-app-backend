/** @namespace req.query.dateFrom * **/
/** @namespace req.query.dateTo * **/
const policyService = require('../services/policiesServices');
const CatchAsync = require('../utils/CatchAsync');
const responseHandler = require('../utils/responseHandler');

const getPolicyInfo = CatchAsync(async (req, res) => {
  await responseHandler(policyService.getPolicyInfoService(req.params.id), res, { statusCode: 200 }, 'success');
});

const getPolicyAnalyticalInfo = CatchAsync(async (req, res) => {
  await responseHandler(
    policyService.getPolicyAnalyticalInfoService(req.params.id, req.query.dateFrom, req.query.dateTo),
    res,
    { statusCode: 200 },
    'success',
  );
});

const getPolicyHistory = CatchAsync(async (req, res) => {
  await responseHandler(
    policyService.getPolicyHistoryService(req.params.id, req.query.dateFrom, req.query.dateTo),
    res,
    { statusCode: 200 },
    'success',
  );
});

const getAllPolicyAnalytics = CatchAsync(async (req, res) => {
  const { policyHistory, policyAnalyticalInfo, excelPath, pdfPath } = await policyService.getAllPolicyAnalyticsService(
    req.params.id,
    req.query.dateFrom,
    req.query.dateTo,
  );

  res.status(200).json({
    status: 'success',
    data: {
      policyHistory,
      policyAnalyticalInfo,
      excelPath,
      pdfPath,
    },
  });
});

const getPolicyHistoryExcelDownload = CatchAsync(async (req, res) => {
  const { excelBuffer } = await policyService.getPolicyHistoryExcelDownloadService(res, req.params.id, '2020.01.01', '2025.01.01');

  res.send(excelBuffer);
});

const getPolicyHistoryPDFDownload = CatchAsync(async (req, res) => {
  const { pdfBuffer, statusCode } = await policyService.getPolicyHistoryPDFDownloadService(res, req.params.id, '2020.01.01', '2025.01.01');

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
