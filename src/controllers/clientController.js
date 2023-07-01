const clientService = require('../services/clientService');
const responseHandler = require('../utils/responseHandler');
const CatchAsync = require('../utils/CatchAsync');
const policyService = require('../services/policiesServices');

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

const getClientHistoryExcelDownload = CatchAsync(async (req, res) => {
  const { excelBuffer } = await clientService.getClientHistoryExcelDownloadService(res, req.params.id, req.query.dateFrom, req.query.dateTo);
  res.status(200).send(excelBuffer);
});

const getClientHistoryPDFDownload = CatchAsync(async (req, res) => {
  const { pdfBuffer } = await clientService.getPolicyHistoryPDFDownloadService(res, req.params.id, req.query.dateFrom, req.query.dateTo);
  res.status(200).send(pdfBuffer);
});

const getAllClientAnalytics = CatchAsync(async (req, res) => {
  const { clientHistory, clientAnalyticalInfo, excelPath, pdfPath } = await clientService.getAllClientAnalyticsService(
    req.params.id,
    req.query.dateFrom,
    req.query.dateTo,
  );

  res.status(200).json({
    status: 'success',
    data: {
      clientHistory,
      clientAnalyticalInfo,
      excelPath,
      pdfPath,
    },
  });
});

module.exports = {
  getClientHistory,
  getClientInfo,
  getClientAnalyticalInfo,
  getClientHistoryExcelDownload,
  getClientHistoryPDFDownload,
  getAllClientAnalytics,
};
