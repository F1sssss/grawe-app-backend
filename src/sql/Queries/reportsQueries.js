const DB_CONFIG = require('../DBconfig');
const DBConnection = require('../DBConnection');
const AppError = require('../../utils/AppError');
const loadSQLQueries = require('../sql_queries/loadSQL');
const { Report, NewReport, NewParam, StoredProcedure, Param } = require('../Queries/params');

const excecuteReportTemplate = async (query, params = [], multiple = false, type = 'query') => {
  const connection = new DBConnection(DB_CONFIG.sql);
  if (query.includes('.sql')) {
    query = await loadSQLQueries(query);
  }
  const result = type === 'query' ? await connection.executeQuery(query, params, multiple) : await connection.executeStoredProcedure(query, params);

  if (!result || result.length === 0) {
    throw new AppError('Error during retrieving reports', 404, 'error-getting-reports-query-result-empty');
  }
  return { result, statusCode: 200 };
};

const getReports = async () => {
  const { result, statusCode } = await excecuteReportTemplate('SELECT * FROM reports (NOLOCK)');
  return { reports: result, statusCode };
};

const getReportById = async (id) => {
  const { result, statusCode } = await excecuteReportTemplate('getReportById.sql', Report(id), true);

  return {
    report_info: result[0][0],
    report_params: result[1],
    statusCode,
  };
};

const getProcedureInfo = async (procedure_name) => {
  const { result, statusCode } = await searchProcedure(procedure_name);
  return {
    procedure_info: result[0][0],
    procedure_params: result[1],
    statusCode,
  };
};

const getParamValues = async (procedure_id, param_name, order) => {
  const { result, statusCode } = await excecuteReportTemplate('getParamValues.sql', Param(procedure_id, param_name, order));
  const values = await excecuteReportTemplate(result['sql']);
  return { param_values: values, statusCode };
};

const executeReport = async (report, inputParams) => {
  const { result, statusCode } = await excecuteReportTemplate(report, inputParams, false, 'storedProcedure');
  return { reportResult: result, statusCode };
};

const searchProcedure = async (procedure_name) => {
  const { result, statusCode } = await excecuteReportTemplate('searchProcedure.sql', StoredProcedure(procedure_name), true);
  return { result, statusCode };
};

const createReport = async (procedure) => {
  const {
    procedure_info: { procedure_id },
    procedure_params,
    new_report_name,
  } = procedure;

  const { report_id } = await insertReport(new_report_name, procedure_id);
  await insertParamSQL(procedure_params, procedure_id, report_id);
  const createdReport = await getReportById(report_id);

  return { createdReport, statusCode: 200 };
};

const insertReport = async (report_name, procedure_id) => {
  const { result, statusCode } = await excecuteReportTemplate('insertReport.sql', NewReport(report_name, procedure_id));
  return { report_id: result.id, statusCode };
};

const insertParamSQL = async (procedure_params, procedure_id, report_id) => {
  procedure_params.map(async (param) => {
    if (param['sql_query'] !== '') {
      await excecuteReportTemplate(
        'insert into reports_param_options (procedure_id,report_id,order_param,param_name,sql) values (@procedure_id,@report_id,@order,@param_name,@sql_query) select * from reports_param_options where report_id=@report_id and order_param=@order',
        NewParam(procedure_id, report_id, param['order'], param['param_name'], param['sql_query']),
      );
    }
  });
  return { new_procedure_params: procedure_params, statusCode: 200 };
};

module.exports = {
  getReports,
  getReportById,
  executeReport,
  createReport,
  getParamValues,
  getProcedureInfo,
};
