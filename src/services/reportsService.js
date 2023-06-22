const reportsQueries = require('../sql/Queries/reportsQueries');
const params = require('../sql/Queries/params');
const cacheQuery = require('../utils/cacheQuery');

const executeReport = async (report_info, report_params, input_params) => {
  const cacheKey = `execute-report-${report_info['procedure_name']}-${JSON.stringify(input_params)}-${JSON.stringify(report_params)}`;
  const queryParams = params.ReportParams(report_params, input_params);
  return ({ reportResult, statusCode } = await cacheQuery(cacheKey, reportsQueries.executeReport(report_info['procedure_name'], queryParams)));
};

const generateReportService = async (id, input_params) => {
  const { report_info, report_params } = await getReportService(id);
  const { reportResult, statusCode } = await executeReport(report_info, report_params, input_params);
  return { reportResult, statusCode };
};

const getReportService = async (id) => {
  const cacheKey = `get-report-${id}`;
  const { report_info, report_params } = await cacheQuery(cacheKey, reportsQueries.getReportById(id));

  return {
    report_info,
    report_params: report_params.map((param) => ({ ...param, sql_query: param['sql_query'] !== '' })),
  };
};

const searchProcedureService = async (procedure_name) => {
  return ({ procedure_info, procedure_params, statusCode } = await reportsQueries.getProcedureInfo(procedure_name));
};

const createReportService = async (procedure) => {
  return ({ createdReport, statusCode } = await reportsQueries.createReport(procedure));
};

module.exports = {
  generateReportService,
  createReportService,
  getReportService,
  searchProcedureService,
};
