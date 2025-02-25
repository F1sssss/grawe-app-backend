const catchAsync = require('../middlewares/CatchAsync');
const reportsQueries = require('../sql/Queries/reportsQueries');
const reportService = require('../services/reportsService');
const responseHandler = require('../utils/responseHandler');

const getReports = catchAsync(async (req, res) => {
  await responseHandler(reportsQueries.getReports(), res, { statusCode: 200 });
});

const getReportById = catchAsync(async (req, res) => {
  await responseHandler(reportService.getReportService(req.params.id), res, { statusCode: 200 });
});

const generateReport = async (req, res, next) => {
  try {
    const id = req.params.id;
    const input_params = req.query;

    const result = await reportService.generateReportService(id, input_params);

    if (result.status === 'completed') {
      res.status(200).json(result.data.reportResult);
    } else {
      res.status(500).json({
        status: 'error',
        message: result.message,
      });
    }
  } catch (error) {
    next(error);
  }
};

const downloadReport = catchAsync(async (req, res) => {
  const { excelBuffer, statusCode } = await reportService.downloadReportService(res, req.params.id, req.query);
  res.status(statusCode).send(excelBuffer);
});

const createReport = catchAsync(async (req, res) => {
  await responseHandler(reportService.createReportService(req.body['procedure']), res, { statusCode: 201 });
});

const getParamValues = catchAsync(async (req, res) => {
  await responseHandler(
    reportsQueries.getParamValues(req.query['procedure_id'], req.query['report_id'], req.query['param_name'], req.query['order']),
    res,
    { statusCode: 200 },
  );
});

const searchProcedure = catchAsync(async (req, res) => {
  await responseHandler(reportService.searchProcedureService(req.query['procedure_name']), res, { statusCode: 200 });
});

const updateReport = catchAsync(async (req, res) => {
  await responseHandler(reportService.updateReportService(req.params.id, req.body), res, { statusCode: 200 });
});

const deleteReport = catchAsync(async (req, res) => {
  await responseHandler(reportService.deleteReportService(req.params.id), res, { statusCode: 200 });
});

const downloadFilteredReport = catchAsync(async (req, res) => {
  const { excelBuffer, statusCode } = await reportService.downloadFilteredReportService(res, req.body['report']);
  res.status(statusCode).send(excelBuffer);
});

module.exports = {
  getReports,
  getReportById,
  generateReport,
  createReport,
  getParamValues,
  searchProcedure,
  updateReport,
  deleteReport,
  downloadReport,
  downloadFilteredReport,
};
