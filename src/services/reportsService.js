const reportsQueries = require('../sql/Queries/reportsQueries');
const params = require('../sql/Queries/params');

const executeReport = async (report, inputParams) => {
  const queryParams = params.ReportParams(report.params, inputParams);
  const { reportResult, statusCode } = await reportsQueries.executeReport(report.procedure_name, queryParams);
  return { reportResult, statusCode };
};

const generateReportService = async (id, inputParams) => {
  const { report } = await reportsQueries.getReportById(id);
  const { reportResult, statusCode } = await executeReport(report, inputParams);
  return { reportResult, statusCode };
};

module.exports = {
  generateReportService,
};
