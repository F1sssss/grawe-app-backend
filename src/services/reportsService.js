const reportsQueries = require('../sql/Queries/reportsQueries');
const params = require('../sql/Queries/params');
const cacheQuery = require('../utils/cacheQuery');
const generateExcelFile = require('../utils/Exports/ExcelExport');
const { delKey } = require('./cachingService');
const ReportQueue = require('../utils/ReportQueue');

const reportQueue = new ReportQueue();

const executeReport = async (report_info, report_params, input_params) => {
  const cacheKey = `execute-report-${report_info['procedure_name']}-${JSON.stringify(input_params).replace(':', '')}-${JSON.stringify(
    report_params,
  ).replace(':', '')}`;
  const queryParams = params.ReportParams(report_params, input_params);
  return ({ reportResult, statusCode } = await cacheQuery(cacheKey, reportsQueries.executeReport(report_info['procedure_name'], queryParams)));
};

const generateReportService = async (id, input_params) => {
  const { report_info, report_params } = await getReportService(id);

  return await reportQueue.getOrQueueReport(id, input_params, async () => {
    return executeReport(report_info, report_params, input_params);
  });
};

const downloadReportService = async (res, id, input_params) => {
  res.setHeader('Content-Type', 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet');
  res.setHeader('Content-Disposition', 'attachment; filename="generated_report.xlsx"');
  const { data } = await generateReportService(id, input_params);
  return ({ excelBuffer, statusCode = 200 } = await generateExcelFile(data.reportResult));
};

const downloadFilteredReportService = async (res, report) => {
  res.setHeader('Content-Type', 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet');
  res.setHeader('Content-Disposition', 'attachment; filename="generated_report.xlsx"');
  return ({ excelBuffer, statusCode = 200 } = await generateExcelFile(report));
};

const getReportService = async (id) => {
  const cacheKey = `get-report-${id}`;
  const { report_info, report_params } = await cacheQuery(cacheKey, reportsQueries.getReportById(id));
  return {
    report_info,
    report_params: Array.isArray(report_params) ? report_params.map((param) => ({ ...param })) : report_params,
  };
};

const searchProcedureService = async (procedure_name) => {
  return ({ procedure_info, procedure_params, statusCode } = await reportsQueries.getProcedureInfo(procedure_name));
};

const createReportService = async (procedure) => {
  await delKey('get-reports');
  await delKey('permissions');
  await delKey('permission-groups');
  return ({ createdReport, statusCode } = await reportsQueries.createReport(procedure));
};

const updateReportService = async (id, report) => {
  await delKey(`get-report-${id}`);
  return ({ updatedReport, statusCode } = await reportsQueries.updateReport(id, report));
};

const deleteReportService = async (id) => {
  await delKey(`get-report-${id}`);
  return ({ deletedReport, statusCode } = await reportsQueries.deleteReport(id));
};

module.exports = {
  generateReportService,
  createReportService,
  getReportService,
  searchProcedureService,
  updateReportService,
  deleteReportService,
  executeReport,
  downloadReportService,
  downloadFilteredReportService,
};
