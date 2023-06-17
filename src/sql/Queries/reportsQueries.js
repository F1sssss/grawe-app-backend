const DB_CONFIG = require('../DBconfig');
const DBConnection = require('../DBConnection');
const AppError = require('../../utils/AppError');
const loadSQLQueries = require('../sql_queries/loadSQL');
const { Report } = require('../Queries/params');

const excecuteReportTemplate = async (query, params, multiple = false, type = 'query') => {
  const connection = new DBConnection(DB_CONFIG.sql);
  if (query.includes('.sql')) {
    query = await loadSQLQueries(query);
  }

  const result = type === 'query' ? await connection.executeQuery(query, params, multiple) : await connection.executeStoredProcedure(query, params);
  if (!result || result.length === 0) {
    throw new AppError('Error during retrieving reports', 404, 'error-getting-reports-query');
  }
  return { result, statusCode: 200 };
};

const getReports = async () => {
  const { reports, statusCode } = await excecuteReportTemplate('SELECT * FROM reports', undefined);
  return { reports, statusCode };
};

const getReportById = async (id) => {
  const { reports, statusCode } = await excecuteReportTemplate('getReportById.sql', Report(id), true);

  return { report: { ...reports[0][0], params: reports[1] }, statusCode };
};

const executeReport = async (report, inputParams) => {
  const { reportResult, statusCode } = await excecuteReportTemplate(report, inputParams, false, 'storedProcedure');
  return { reportResult, statusCode };
};

module.exports = {
  getReports,
  getReportById,
  executeReport,
};
