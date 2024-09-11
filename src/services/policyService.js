const PolicyQueries = require('../sql/Queries/PoliciesQueries');
const generateExcelFile = require('../utils/Exports/ExcelExport');
const Invoice = require('../utils/Exports/createInvoice');
const cacheQuery = require('../utils/cacheQuery');

const getPolicyInfoService = async (id) => {
  const cacheKey = `policy-info-${id}`;
  return ({ policy, statusCode } = await cacheQuery(cacheKey, PolicyQueries.getPolicyInfo(id)));
};

const getPolicyAnalyticalInfoService = async (id, dateFrom, dateTo) => {
  const cacheKey = `policy-analytical-info-${id}-${dateFrom}-${dateTo}`;
  return ({ policy, statusCode } = await cacheQuery(cacheKey, PolicyQueries.getPolicyAnalyticalInfo(id, dateFrom, dateTo)));
};

const getPolicyHistoryService = async (id, dateFrom, dateTo) => {
  const cacheKey = `policy-history-${id}-${dateFrom}-${dateTo}`;
  return ({ policy, statusCode } = await cacheQuery(cacheKey, PolicyQueries.getPolicyHistory(id, dateFrom, dateTo)));
};

const getAllPolicyAnalyticsService = async (id, dateFrom, dateTo) => {
  const policyHistory = await getPolicyHistoryService(id, dateFrom, dateTo);
  const policyAnalyticalInfo = await getPolicyAnalyticalInfoService(id, dateFrom, dateTo);

  return {
    policyHistory,
    policyAnalyticalInfo,
    excelPath: `http://localhost:3000/api/v1/policies/${id}/history/xls/download?dateFrom=${dateFrom}&dateTo=${dateTo}`,
    pdfPath: `http://localhost:3000/api/v1/policies/${id}/history/pdf/download?dateFrom=${dateFrom}&dateTo=${dateTo}`,
  };
};

const getPolicyHistoryExcelDownloadService = async (res, id, dateFrom, dateTo) => {
  res.setHeader('Content-Type', 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet');
  res.setHeader('Content-Disposition', 'attachment; filename="example.xlsx"');
  const { policy } = await getPolicyHistoryService(id, dateFrom, dateTo);
  return ({ excelBuffer, statusCode } = await generateExcelFile(policy));
};

const getPolicyHistoryPDFDownloadService = async (res, id, dateFrom, dateTo) => {
  res.setHeader('Content-Type', 'application/pdf');
  res.setHeader('Content-Disposition', 'attachment; filename="Invoice.pdf"');
  const { policy } = await PolicyQueries.getPolicyExcelInfo(id, dateFrom, dateTo);
  return ({ pdfBuffer, statusCode } = await Invoice.createInvoice(policy));

  //const { policy } = await getPolicyHistoryService(id, dateFrom, dateTo);
  //return ({ pdfBuffer, statusCode } = await Invoice.createInvoice(policy));
};

module.exports = {
  getPolicyHistoryService,
  getPolicyInfoService,
  getPolicyHistoryExcelDownloadService,
  getPolicyHistoryPDFDownloadService,
  getPolicyAnalyticalInfoService,
  getAllPolicyAnalyticsService,
};
