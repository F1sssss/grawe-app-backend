const handleResponse = require('../utils/responseHandler');
const catchAsync = require('../middlewares/CatchAsync');
const employeeErrorQueries = require('../sql/Queries/employeeErrorQueries');

const getAllEmployeeErrors = async (req, res) => {
  await handleResponse(employeeErrorQueries.getEmployeeErrors(req.query.date), res, { statusCode: 200 });
};

const getAllExceptions = catchAsync(async (req, res) => {
  await handleResponse(employeeErrorQueries.getErrorExceptions(), res, { statusCode: 200 });
});

const addErrorException = catchAsync(async (req, res) => {
  await handleResponse(employeeErrorQueries.addErrorException(req.query.policy, req.query.id, req.body.exception, req), res, { statusCode: 200 });
});

const deleteErrorException = catchAsync(async (req, res) => {
  await handleResponse(employeeErrorQueries.deleteErrorException(req.query.policy, req.query.id), res, { statusCode: 200 });
});

module.exports = {
  getAllEmployeeErrors,
  getAllExceptions,
  addErrorException,
  deleteErrorException,
};
