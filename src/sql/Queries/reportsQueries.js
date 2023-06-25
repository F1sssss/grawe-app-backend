const DB_CONFIG = require('../DBconfig');
const DBConnection = require('../DBConnection');
const AppError = require('../../utils/AppError');
const loadSQLQueries = require('../sql_queries/loadSQL');
const { Report, NewReport, NewParam, StoredProcedure, Param, ReportProcedure, ReportName } = require('../Queries/params');

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

const getParamValues = async (procedure_id, report_id, param_name, order) => {
  const { result, statusCode } = await excecuteReportTemplate('getParamValues.sql', Param(procedure_id, report_id, param_name, order));
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
    await excecuteReportTemplate(
      'insert_update_reportParams.sql',
      NewParam(procedure_id, report_id, param['order'], param['param_name'], param['sql_query']),
    );
  });
  return { new_procedure_params: procedure_params, statusCode: 200 };
};

const updateReport = async (id, report) => {
  const { report_info, report_params } = await getReportById(id);
  const { report_name, procedure_id } = report_info;

  if (procedure_id !== report.report_info.procedure_id) {
    await excecuteReportTemplate('updateReportProcedure.sql', ReportProcedure(id, report.report_info.procedure_id));
    await insertParamSQL(report.report_params, report.report_info.procedure_id, report.report_info.report_id);
  }
  if (report_name !== report.report_info.report_name) {
    await excecuteReportTemplate(
      'update reports set report_name=@report_name where id=@id select * from reports where id=@id',
      ReportName(id, report.report_info.report_name),
    );
  }

  if (JSON.stringify(report_params) !== JSON.stringify(report.report_params)) {
    report.report_params.map(async (param, index) => {
      await insertParamSQL([param], procedure_id, id);
    });
  }

  return { updatedReport: await getReportById(id), statusCode: 200 };
};

module.exports = {
  getReports,
  getReportById,
  executeReport,
  createReport,
  getParamValues,
  getProcedureInfo,
  updateReport,
};
