//Controller for errors in grawe data and exceptions

const handleResponse = require('../utils/responseHandler');
const catchAsync = require('../utils/CatchAsync');
const employeeErrorQueries = require('../sql/Queries/employeeErrorQueries');

const getAllEmployeeErrors = catchAsync(async (req, res) => {
  await handleResponse(employeeErrorQueries.getEmployeeErrors(req.query.date), res, { statusCode: 200 }, 'employee_errors');
});

const getAllExceptions = catchAsync(async (req, res) => {
  await handleResponse(employeeErrorQueries.getErrorExceptions(), res, { statusCode: 200 }, 'exceptions');
});

const addErrorException = catchAsync(async (req, res) => {
  await handleResponse(
    employeeErrorQueries.addErrorException(req.query.policy, req.query.id, req.body.exception),
    res,
    { statusCode: 200 },
    'result',
  );
});

const deleteErrorException = catchAsync(async (req, res) => {
  await handleResponse(employeeErrorQueries.deleteErrorException(req.query.policy, req.query.id), res, { statusCode: 200 }, 'deleted exception');
});

const updateErrorException = catchAsync(async (req, res) => {
  await handleResponse(
    employeeErrorQueries.updateErrorException(req.query.policy, req.query.id, req.body.exception),
    res,
    { statusCode: 200 },
    'updated exception',
  );
});

module.exports = {
  getAllEmployeeErrors,
  getAllExceptions,
  addErrorException,
  deleteErrorException,
  updateErrorException,
};
