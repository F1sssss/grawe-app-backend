const AppError = require('../utils/appError');
const PolicyQueries = require('../sql/Queries/PoliciesQueries');
const generateExcelFile = require('../utils/excelExport');
const Invoice = require('../utils/createInvoice');
const { get, setWithTTL } = require('../services/cachingService');

const getPolicyTemplate = async (cacheKey, policyQuery) => {
  const cacheData = await get(cacheKey);

  if (cacheData) {
    return { policy: cacheData, statusCode: 200 };
  }

  const { policy, statusCode } = await policyQuery;

  await setWithTTL(cacheKey, JSON.stringify(policy));

  return { policy, statusCode };
};

const getPolicyInfoService = async (id) => {
  const cacheKey = `policy-info-${id}`;
  return ({ policy, statusCode } = await getPolicyTemplate(cacheKey, PolicyQueries.getPolicyInfo(id)));
};

const getPolicyAnalyticalInfoService = async (id, dateFrom, dateTo) => {
  const cacheKey = `policy-analytical-info-${id}-${dateFrom}-${dateTo}`;
  return ({ policy, statusCode } = await getPolicyTemplate(cacheKey, PolicyQueries.getPolicyAnalyticalInfo(id, dateFrom, dateTo)));
};

const getPolicyHistoryService = async (id, dateFrom, dateTo) => {
  const cacheKey = `policy-history-${id}-${dateFrom}-${dateTo}`;
  return ({ policy, statusCode } = await getPolicyTemplate(cacheKey, PolicyQueries.getPolicyHistory(id, dateFrom, dateTo)));
};

const getAllPolicyAnalyticsService = async (id, dateFrom, dateTo) => {
  const policyHistory = await getPolicyHistoryService(id, dateFrom, dateTo);
  const policyAnalyticalInfo = await getPolicyAnalyticalInfoService(id, dateFrom, dateTo);

  return {
    policyHistory,
    policyAnalyticalInfo,
    excelPath: `http://localhost:3000/api/v1/policies/${id}/history/xls/download`,
    pdfPath: `http://localhost:3000/api/v1/policies/${id}/history/pdf/download`,
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
  const { policy } = await getPolicyHistoryService(id, dateFrom, dateTo);
  return ({ pdfBuffer, statusCode } = await Invoice.createInvoice(policy));
};

module.exports = {
  getPolicyHistoryService,
  getPolicyInfoService,
  getPolicyHistoryExcelDownloadService,
  getPolicyHistoryPDFDownloadService,
  getPolicyAnalyticalInfoService,
  getAllPolicyAnalyticsService,
};
