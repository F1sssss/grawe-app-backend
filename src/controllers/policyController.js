const policyService = require('../services/policiesServices');
const CatchAsync = require('../utils/CatchAsync');

const getPolicyInfo = CatchAsync(async (req, res) => {
  const { policies, statusCode } = await policyService.getPolicyInfoService(req.params.id);

  res.status(statusCode).json({
    status: 'success',
    policies
  });
});

const getPolicyAnalyticalInfo = CatchAsync(async (req, res) => {
  const { policy, statusCode } = await policyService.getPolicyAnalyticalInfoService(req.params.id, req.query.dateFrom, req.query.dateTo);

  res.status(statusCode).json({
    status: 'success',
    policy
  });
});

const getPolicyHistory = CatchAsync(async (req, res) => {
  const { policy, statusCode } = await policyService.getPolicyHistoryService(req.params.id, req.query.dateFrom, req.query.dateTo);

  res.status(statusCode).json({
    status: 'success',
    policy
  });
});

const getAllPolicyAnalytics = CatchAsync(async (req, res) => {
  const { policyHistory, policyAnalyticalInfo, excelPath, pdfPath } = await policyService.getAllPolicyAnalyticsService(
    req.params.id,
    req.query.dateFrom,
    req.query.dateTo
  );

  res.status(200).json({
    status: 'success',
    policyHistory,
    policyAnalyticalInfo,
    excelPath,
    pdfPath
  });
});

const getPolicyHistoryExcelDownload = CatchAsync(async (req, res) => {
  // Set the response headers for file download
  res.setHeader('Content-Type', 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet');
  res.setHeader('Content-Disposition', 'attachment; filename="example.xlsx"');

  const { excelBuffer } = await policyService.getPolicyHistoryExcelDownloadService(req.params.id, '2020.01.01', '2025.01.01');

  res.send(excelBuffer);
});

const getPolicyHistoryPDFDownload = CatchAsync(async (req, res) => {
  const { pdfBuffer, statusCode } = await policyService.getPolicyHistoryPDFDownloadService(req.params.id, '2020.01.01', '2025.01.01');

  res.setHeader('Content-Type', 'application/pdf');
  res.setHeader('Content-Disposition', 'attachment; filename="Invoice.pdf"');

  res.status(statusCode).send(pdfBuffer);
});

module.exports = {
  getPolicyHistory,
  getPolicyInfo,
  getPolicyHistoryExcelDownload,
  getPolicyHistoryPDFDownload,
  getPolicyAnalyticalInfo,
  getAllPolicyAnalytics
};
