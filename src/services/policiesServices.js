const AppError = require('../utils/appError');
const PolicyQueries = require('../sql/Queries/PoliciesQueries');
const generateExcelFile = require('../utils/excelExport');
const Invoice = require('../utils/PDFCreation/createInvoice');

const getPolicyHistory = async (id) => {
  const { policy, statusCode } = await PolicyQueries.getPolicyHistory(id);

  if (!policy || statusCode !== 200) {
    throw new AppError('Error during retrieving policy history', 404);
  }

  return { policy, statusCode };
};

const getPolicyInfoService = async (id) => {
  const { policies, statusCode } = await PolicyQueries.getPolicyInfo(id);

  if (!policies || statusCode !== 200) {
    throw new AppError('Policy not found by id!', 404);
  }

  return { policies, statusCode };
};

const getPolicyHistoryExcelDownloadService = async (id) => {
  const { policy, statusCode } = await PolicyQueries.getPolicyHistory(id);

  const { excelBuffer } = await generateExcelFile(policy);

  if (!policy || !excelBuffer || statusCode !== 200) {
    throw new AppError('Error during retrieving policy history', 404);
  }

  return { excelBuffer, statusCode };
};

const getPolicyHistoryPDFDownloadService = async (id) => {
  const { pdfBuffer, statusCode } = await Invoice.createInvoice(id);

  if (!pdfBuffer || statusCode !== 200) {
    throw new AppError('Error during retrieving policy history', 404);
  }

  return { pdfBuffer, statusCode };
};

module.exports = {
  getPolicyHistory,
  getPolicyInfoService,
  getPolicyHistoryExcelDownloadService,
  getPolicyHistoryPDFDownloadService
};
