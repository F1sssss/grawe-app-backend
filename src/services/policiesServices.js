const AppError = require('../utils/appError');
const PolicyQueries = require('../sql/Queries/PoliciesQueries');
const generateExcelFile = require('../utils/excelExport');
const Invoice = require('../utils/createInvoice');
const { get, setWithTTL } = require('../services/cachingService');

const getPolicyHistoryService = async (id, dateFrom, dateTo) => {
  const cacheKey = `policy-history-${id}-${dateFrom}-${dateTo}`;
  const cacheData = await get(cacheKey);

  if (cacheData) {
    return { policy: cacheData, statusCode: 200 };
  }

  const { policy, statusCode } = await PolicyQueries.getPolicyHistory(id, dateFrom, dateTo);

  await setWithTTL(cacheKey, JSON.stringify(policy));

  return { policy, statusCode };
};

const getPolicyInfoService = async (id) => {
  const cacheKey = `policy-info-${id}`;
  const cacheData = await get(cacheKey);

  if (cacheData) {
    return { policies: cacheData, statusCode: 200 };
  }

  const { policies, statusCode } = await PolicyQueries.getPolicyInfo(id);

  await setWithTTL(cacheKey, JSON.stringify(policies));

  return { policies, statusCode };
};

const getPolicyAnalyticalInfoService = async (id, dateFrom, dateTo) => {
  const cacheKey = `policy-analytical-info-${id}-${dateFrom}-${dateTo}`;
  const cacheData = await get(cacheKey);

  if (cacheData) {
    return { policy: cacheData, statusCode: 200 };
  }

  const { policy, statusCode } = await PolicyQueries.getPolicyAnalyticalInfo(id, dateFrom, dateTo);

  await setWithTTL(cacheKey, JSON.stringify(policy));

  return { policy, statusCode };
};

const getAllPolicyAnalyticsService = async (id, dateFrom, dateTo) => {
  const policyHistory = await getPolicyHistoryService(id, dateFrom, dateTo);
  const policyAnalyticalInfo = await getPolicyAnalyticalInfoService(id, dateFrom, dateTo);

  return {
    policyHistory,
    policyAnalyticalInfo,
    excelPath: `http://localhost:3000/api/v1/policies/${id}/history/xls/download`,
    pdfPath: `http://localhost:3000/api/v1/policies/${id}/history/pdf/download`
  };
};

const getPolicyHistoryExcelDownloadService = async (id, dateFrom, dateTo) => {
  const { policy, statusCode } = await getPolicyHistoryService(id, dateFrom, dateTo);

  const { excelBuffer } = await generateExcelFile(policy);

  if (!policy || !excelBuffer || statusCode !== 200) {
    throw new AppError('Error during retrieving policy history', 404, 'error-getting-policy-history-excel');
  }

  return { excelBuffer, statusCode };
};

const getPolicyHistoryPDFDownloadService = async (id, dateFrom, dateTo) => {
  const { policy, statusCode } = await getPolicyHistoryService(id, dateFrom, dateTo);
  const { pdfBuffer } = await Invoice.createInvoice(policy);

  if (!pdfBuffer || statusCode !== 200) {
    throw new AppError('Error during retrieving policy history', 404, 'error-getting-policy-history-pdf');
  }

  return { pdfBuffer, statusCode };
};

module.exports = {
  getPolicyHistoryService,
  getPolicyInfoService,
  getPolicyHistoryExcelDownloadService,
  getPolicyHistoryPDFDownloadService,
  getPolicyAnalyticalInfoService,
  getAllPolicyAnalyticsService
};
