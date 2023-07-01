const sql = require('mssql');
const DB_CONFIG = require('../DBconfig');
const DBConnection = require('../DBConnection');
const AppError = require('../../utils/AppError');
const loadSQLQueries = require('../sql_queries/loadSQL');
const { Report, NewReport, NewParam, StoredProcedure, Param, ReportProcedure, ReportName } = require('../Queries/params');
const SQLParam = require('../SQLParam');

function isNullOrEmpty(str) {
  return !str || !str.trim();
}

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

const getReportByName = async (report_name) => {
  const { result, statusCode } = await excecuteReportTemplate('getReportByName.sql', ReportName(0, report_name), true);

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

  if (isNullOrEmpty(result.sql)) {
    throw new AppError('Params query is empty!', 404, 'error-param-query-empty');
  }

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

//This function is used to insert a new report and its params, and returns the new report (with its params)
const createReport = async (procedure) => {
  const {
    procedure_info: { procedure_id },
    procedure_params,
    new_report_name,
  } = procedure;

  if (
    isNullOrEmpty(new_report_name) ||
    procedure_id === undefined ||
    procedure_params.length === 0 ||
    (await getReportByName(new_report_name))?.report_info?.report_name === new_report_name
  ) {
    throw new AppError('Invalid report data!', 404, 'error-invalid-report-data');
  }

  const { report_id } = await insertReportSQL(new_report_name, procedure_id);
  await insertParamSQL(procedure_params, procedure_id, report_id);
  const createdReport = await getReportById(report_id);

  return { createdReport, statusCode: 200 };
};

//These 2 functions are helper to createReport and are used to insert rows into SQL table
const insertReportSQL = async (report_name, procedure_id) => {
  const { result, statusCode } = await excecuteReportTemplate('insertReport.sql', NewReport(report_name, procedure_id));
  return { report_id: result.id, statusCode };
};
//Insert Prams inserts the params of the report or updates them if they already exist
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

  //If the procedure_id or report_name is changed, we need to update the report and its params
  if (procedure_id !== report.report_info.procedure_id) {
    await excecuteReportTemplate('updateReportProcedure.sql', ReportProcedure(id, report.report_info.procedure_id));
    await insertParamSQL(report.report_params, report.report_info.procedure_id, report.report_info.report_id);
  }
  if (report_name !== report.report_info.report_name) {
    if ((await getReportByName(report.report_info.report_name))?.report_info?.report_name !== undefined) {
      throw new AppError('Report name already exists!', 404, 'error-report-name-already-exists');
    }
    await excecuteReportTemplate(
      'update reports set report_name=@report_name where id=@id select * from reports where id=@id',
      ReportName(id, report.report_info.report_name),
    );
  }
  //If the report_params is changed, we need to update the report params
  if (JSON.stringify(report_params) !== JSON.stringify(report.report_params)) {
    report.report_params.map(async (param) => {
      await insertParamSQL([param], procedure_id, id);
    });
  }

  return { updatedReport: await getReportById(id), statusCode: 200 };
};

const deleteReport = async (id) => {
  const connection = new DBConnection(DB_CONFIG.sql);
  const user = await connection.executeQuery(
    `delete from reports where id = @id
           delete from reports_param_options where report_id = @id
           select * from reports  (nolock) where id = @id`,
    [new SQLParam('id', id, sql.Int)],
  );

  if (user) {
    throw new AppError('Error deleting report!', 401, 'error-deleting-report-not-found');
  }

  return { message: 'Report Deleted!', statusCode: 200 };
};

module.exports = {
  getReports,
  getReportById,
  executeReport,
  createReport,
  getParamValues,
  getProcedureInfo,
  updateReport,
  getReportByName,
  deleteReport,
};
