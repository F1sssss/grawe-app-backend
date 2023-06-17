const catchAsync = require('../utils/catchAsync');
const reportsQueries = require('../sql/Queries/reportsQueries');
const reportService = require('../services/reportsService');

const getReports = catchAsync(async (req, res) => {
  const { reports, statusCode } = await reportsQueries.getReports();

  res.status(statusCode).json({
    status: 'success',
    reports,
  });
});

const getReportById = catchAsync(async (req, res) => {
  const { report, statusCode } = await reportsQueries.getReportById(req.params.id);

  res.status(statusCode).json({
    status: 'success',
    report,
  });
});

const generateReport = catchAsync(async (req, res) => {
  const { reportResult, statusCode } = await reportService.generateReportService(req.params.id, req.query);

  res.status(statusCode).json({
    status: 'success',
    reportResult,
  });
});

module.exports = {
  getReports,
  getReportById,
  generateReport,
};
