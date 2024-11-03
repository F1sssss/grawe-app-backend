const cacheQuery = require('../utils/cacheQuery');
const ClientQueries = require('../sql/Queries/clientQueries');
const generateExcelFile = require('../utils/Exports/ExcelExport');
const Invoice = require('../utils/Exports/createInvoice');
const FinancialInvoice = require('../utils/Exports/createFinancialInvoice');
const AppError = require('../utils/AppError');

function seperateClientPolicies(client) {
  const arraysByPolisa = {};

  if (!Array.isArray(client)) {
    return client;
  }

  client.forEach((item) => {
    const policy = item.polisa;
    !arraysByPolisa[policy] ? (arraysByPolisa[policy] = []) : undefined;
    arraysByPolisa[policy].push(item);
  });

  return Object.values(arraysByPolisa);
}

const getClientHistoryService = async (id, dateFrom, dateTo) => {
  const cacheKey = `client-history-${id}-${dateFrom}-${dateTo}`;
  const { client, statusCode } = await cacheQuery(cacheKey, ClientQueries.getClientHistory(id, dateFrom, dateTo));
  return { client, statusCode };
};

const getClientInfoService = async (id) => {
  const cacheKey = `client-info-${id}`;
  const { client, statusCode } = await cacheQuery(cacheKey, ClientQueries.getClientInfo(id));
  return { client, statusCode };
};

const getClientAnalyticalInfoService = async (id, dateFrom, dateTo) => {
  const cacheKey = `client-analytical-info-${id}-${dateFrom}-${dateTo}`;
  const { client, statusCode } = await cacheQuery(cacheKey, ClientQueries.getClientAnalyticalInfo(id, dateFrom, dateTo));
  return { client, statusCode };
};

const getClientPolicyAnalyticalInfoService = async (id, dateFrom, dateTo) => {
  const cacheKey = `client-policy-analytics-${id}-${dateFrom}-${dateTo}`;
  const { client, statusCode } = await cacheQuery(cacheKey, ClientQueries.getClientPolicyAnalticalInfo(id, dateFrom, dateTo));
  return { client, statusCode };
};

const getClientHistoryExcelDownloadService = async (res, id, dateFrom, dateTo) => {
  res.setHeader('Content-Type', 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet');
  res.setHeader('Content-Disposition', 'attachment; filename="client.xlsx"');
  const { client } = await getClientHistoryService(id, dateFrom, dateTo);
  return ({ excelBuffer, statusCode } = await generateExcelFile(client));
};

const getPolicyHistoryPDFDownloadService = async (res, id, dateFrom, dateTo, ZK, AO) => {
  res.setHeader('Content-Type', 'application/pdf');
  let filename = `attachment; filename="KarticaKlijenta-${id}-${dateTo}.pdf"`;
  res.setHeader('Content-Disposition', filename);
  ZK = ZK === undefined ? 1 : ZK;
  AO = AO === undefined ? 1 : AO;
  const cacheKey = `client-analytics-all-${id}-${dateFrom}-${dateTo}-${ZK}-${AO}`;
  let { client } = await cacheQuery(cacheKey, ClientQueries.getAllClientInfoFiltered(id, dateFrom, dateTo, ZK, AO));
  client = seperateClientPolicies(client);
  return ({ pdfBuffer, statusCode } = await Invoice.createClientInvoice(client));
};

const getAllClientAnalyticsService = async (id, dateFrom, dateTo) => {
  const clientHistory = await getClientHistoryService(id, dateFrom, dateTo);
  const clientAnalyticalInfo = await getClientAnalyticalInfoService(id, dateFrom, dateTo);

  return {
    clientHistory,
    clientAnalyticalInfo,
    excelPath: `http://localhost:3000/api/v1/clients/${id}/history/xls/download?dateFrom=${dateFrom}&dateTo=${dateTo}`,
    pdfPath: `http://localhost:3000/api/v1/clients/${id}/history/pdf/download?dateFrom=${dateFrom}&dateTo=${dateTo}`,
  };
};

const getAllClientInfoService = async (id, dateFrom, dateTo) => {
  const cacheKey = `client-analytics-all-${id}-${dateFrom}-${dateTo}`;
  let { client } = await cacheQuery(cacheKey, ClientQueries.getAllClientInfo(id, dateFrom, dateTo));
  client = seperateClientPolicies(client);
  return { client, statusCode: 200 };
};

const getClientFinancialHistoryPDFDownloadService = async (res, id, dateFrom, dateTo, ZK, AO) => {
  res.setHeader('Content-Type', 'application/pdf');
  let filename = `attachment; filename="KarticaKlijenta-${id}-${dateTo}.pdf"`;
  res.setHeader('Content-Disposition', filename);
  ZK = ZK === undefined ? 1 : ZK;
  AO = AO === undefined ? 1 : AO;
  const cacheKey = `client-fin-analytics-all-${id}-${dateFrom}-${dateTo}-${ZK}-${AO}`;
  let { client } = await cacheQuery(cacheKey, getClientFinancialInfoService(id, dateFrom, dateTo, ZK, AO));
  if (!client || !client.finHistory.length) throw new AppError('No financial history found', 404, 'no-financial-history');
  return ({ pdfBuffer, statusCode } = await FinancialInvoice.createClientInvoice(client));
};

const getClientFinancialInfoService = async (id, dateFrom, dateTo, ZK, AO) => {
  let { clientFinHistory } = await ClientQueries.getClientFinancialHistory(id, dateFrom, dateTo, ZK, AO);
  let { clientFinInfo } = await ClientQueries.getClientFinancialInfo(id, dateFrom, dateTo, ZK, AO);

  const { client } = await getClientInfoService(id);

  return { client: { finHistory: clientFinHistory, info: { ...client }, finInfo: clientFinInfo } };
};

module.exports = {
  getClientHistoryService,
  getClientInfoService,
  getClientAnalyticalInfoService,
  getClientHistoryExcelDownloadService,
  getPolicyHistoryPDFDownloadService,
  getAllClientAnalyticsService,
  getAllClientInfoService,
  getClientPolicyAnalyticalInfoService,
  getClientFinancialHistoryPDFDownloadService,
  getClientFinancialInfoService,
};
