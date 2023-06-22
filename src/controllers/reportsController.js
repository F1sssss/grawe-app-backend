const catchAsync = require('../utils/catchAsync');
const reportsQueries = require('../sql/Queries/reportsQueries');
const reportService = require('../services/reportsService');
const responseHandler = require('../utils/responseHandler');

const getReports = catchAsync(async (req, res) => {
  await responseHandler(reportsQueries.getReports(), res, { statusCode: 200 }, 'Successfully got reports');
});

const getReportById = catchAsync(async (req, res) => {
  await responseHandler(reportService.getReportService(req.params.id), res, { statusCode: 200 }, 'Succesfully got report');
});

const generateReport = catchAsync(async (req, res) => {
  await responseHandler(reportService.generateReportService(req.params.id, req.query), res, { statusCode: 200 }, 'Success');
});

const createReport = catchAsync(async (req, res) => {
  await responseHandler(reportService.createReportService(req.body['procedure']), res, { statusCode: 201 }, 'Successfully created report');
});

const getParamValues = catchAsync(async (req, res) => {
  await responseHandler(
    reportsQueries.getParamValues(req.query['procedure_id'], req.query['param_name'], req.query['order']),
    res,
    { statusCode: 200 },
    'Succesfully got param values',
  );
});

const searchProcedure = catchAsync(async (req, res) => {
  await responseHandler(reportService.searchProcedureService(req.query['procedure_name']), res, { statusCode: 200 }, 'Search results:');
});

module.exports = {
  getReports,
  getReportById,
  generateReport,
  createReport,
  getParamValues,
  searchProcedure,
};
