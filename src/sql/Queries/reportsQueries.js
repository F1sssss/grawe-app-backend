const { executeQueryAndHandleErrors } = require('../executeQuery');
const AppError = require('../../utils/AppError');
const { Report, NewReport, NewParam, StoredProcedure, Param, ReportProcedure, ReportName, ReportId } = require('../Queries/params');

function isNullOrEmpty(str) {
  return !str || !str.trim();
}

const getReports = async () => {
  const { data, statusCode } = await executeQueryAndHandleErrors('SELECT * FROM reports (NOLOCK)');
  return { reports: data, statusCode };
};

const getReportById = async (id) => {
  const { data, statusCode } = await executeQueryAndHandleErrors('get_report_id.sql', Report(id), true);

  return {
    report_info: data[0][0] === undefined ? {} : data[0][0],
    report_params: data[1] === undefined ? {} : data[1],
    statusCode,
  };
};

const getReportByName = async (report_name) => {
  const { data, statusCode } = await executeQueryAndHandleErrors('get_report_name.sql', ReportName(0, report_name), true);

  return {
    report_info: data[0][0] === undefined ? {} : data[0][0],
    report_params: data[1] === undefined ? {} : data[1],
    statusCode,
  };
};

const getProcedureInfo = async (procedure_name) => {
  const { data, statusCode } = await searchProcedure(procedure_name);

  return {
    procedure_info: data[0][0] === undefined ? {} : data[0][0],
    procedure_params: data[1] === undefined ? {} : data[1],
    statusCode,
  };
};

const getParamValues = async (procedure_id, report_id, param_name, order) => {
  const { data, statusCode } = await executeQueryAndHandleErrors('get_reports_param_values.sql', Param(procedure_id, report_id, param_name, order));

  if (isNullOrEmpty(data.sql)) {
    throw new AppError('Params query is empty!', 404, 'error-param-query-empty');
  }

  const { data: param_values } = await executeQueryAndHandleErrors(data['sql']);

  return { param_values, statusCode };
};

const executeReport = async (report, inputParams) => {
  const { data, statusCode } = await executeQueryAndHandleErrors(report, inputParams, false, 'storedProcedure');
  return { reportResult: data, statusCode };
};

const searchProcedure = async (procedure_name) => {
  const { data, statusCode } = await executeQueryAndHandleErrors('get_report_search_procedures.sql', StoredProcedure(procedure_name), true);
  return { data, statusCode };
};

//This function is used to insert a new report and its params, and returns the new report (with its params)
const createReport = async (procedure) => {
  const {
    procedure_info: { procedure_id },
    procedure_params,
    new_report_name,
  } = procedure;

  if (isNullOrEmpty(new_report_name) || procedure_id === undefined || procedure_params.length === 0) {
    throw new AppError('Invalid report data!', 404, 'error-invalid-report-data');
  }

  const { report_id } = await insertReport(new_report_name, procedure_id);
  await insertParamSQL(procedure_params, procedure_id, report_id);
  const createdReport = await getReportById(report_id);

  return { createdReport, statusCode: 200 };
};

//These 2 functions are helper to createReport and are used to insert rows into SQL table
const insertReport = async (report_name, procedure_id) => {
  const { data, statusCode } = await executeQueryAndHandleErrors('add_report.sql', NewReport(report_name, procedure_id));
  return { report_id: data.id, statusCode };
};

//Insert Prams inserts the params of the report or updates them if they already exist
const insertParamSQL = async (procedure_params, procedure_id, report_id) => {
  procedure_params.map(async (param) => {
    await executeQueryAndHandleErrors(
      'update_report_params.sql',
      NewParam(procedure_id, report_id, param['order'], param['param_name'], param['sql_query']),
    );
  });
  return { new_procedure_params: procedure_params, statusCode: 200 };
};

const updateReport = async (id, report) => {
  const {
    report_info: { report_name, procedure_id },
    report_params,
  } = await getReportById(id);

  //If the procedure_id or report_name is changed, we need to update the report and its params
  if (procedure_id !== report.report_info.procedure_id) {
    await updateReportProcedure(id, report);
  }

  //If the report_name is changed, we need to update the report name
  if (report_name !== report.report_info.report_name) {
    await updateReportName(id, report);
  }

  //If the report_params is changed, we need to update the report params
  if (JSON.stringify(report_params) !== JSON.stringify(report.report_params)) {
    report.report_params.map(async (param) => {
      await insertParamSQL([param], procedure_id, id);
    });
  }

  return { updatedReport: await getReportById(id), statusCode: 200 };
};

const updateReportProcedure = async (id, report) => {
  await executeQueryAndHandleErrors('update_report_procedure.sql', ReportProcedure(id, report.report_info.procedure_id));
  await insertParamSQL(report.report_params, report.report_info.procedure_id, report.report_info.report_id);
};

const updateReportName = async (id, report) => {
  if ((await getReportByName(report.report_info.report_name))?.report_info?.report_name !== undefined) {
    throw new AppError('Report name already exists!', 404, 'error-report-name-already-exists');
  }
  await executeQueryAndHandleErrors('update_report_name.sql', ReportName(id, report.report_info.report_name));
};

const deleteReport = async (id) => {
  await executeQueryAndHandleErrors('delete_report.sql', ReportId(id));
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
