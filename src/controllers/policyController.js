const policyService = require('../services/policiesServices');
const CatchAsync = require('../utils/CatchAsync');

const getPolicyInfo = CatchAsync(async (req, res) => {
  const { policies, statusCode } = await policyService.getPolicyInfoService(
    req.query.policy
  );

  res.status(statusCode).json({
    status: 'success',
    policies
  });
});

const getPolicyHistory = CatchAsync(async (req, res) => {
  const { policy, statusCode } = await policyService.getPolicyHistory(
    req.query.policy
  );

  res.status(statusCode).json({
    status: 'success',
    policy
  });
});

const getPolicyHistoryExcelDownload = CatchAsync(async (req, res) => {
  // Set the response headers for file download
  res.setHeader(
    'Content-Type',
    'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'
  );
  res.setHeader('Content-Disposition', 'attachment; filename="example.xlsx"');

  const { excelBuffer } =
    await policyService.getPolicyHistoryExcelDownloadService(req.query.policy);

  res.send(excelBuffer);
});

const getPolicyHistoryPDFDownload = CatchAsync(async (req, res) => {
  const { pdfBuffer, statusCode } =
    await policyService.getPolicyHistoryPDFDownloadService(req.query.policy);

  res.setHeader(
    'Content-Type',
    'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'
  );
  res.setHeader('Content-Disposition', 'attachment; filename="Invoice.pdf"');

  res.status(statusCode).send(pdfBuffer);
});

module.exports = {
  getPolicyHistory,
  getPolicyInfo,
  getPolicyHistoryExcelDownload,
  getPolicyHistoryPDFDownload
};
