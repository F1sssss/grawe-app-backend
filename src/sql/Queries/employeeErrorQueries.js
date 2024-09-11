const DB_CONFIG = require('../DBconfig');
const DBConnection = require('../DBConnection');
const AppError = require('../../utils/AppError');
const { getPolicyInfo } = require('./PoliciesQueries');
const { Date, Exception } = require('../Queries/params');
const { getMeService } = require('../../services/userService');

const excecuteQueryAndHandleErrors = async (query, params = []) => {
  const connection = new DBConnection(DB_CONFIG.sql);
  const result = await connection.executeQuery(query, params);

  if ((!result || result.length === 0) && query === 'add_error_exception.sql') {
    throw new AppError('Error during retrieving errors', 404, 'error-getting-errors-query-result-empty');
  }

  return { result, statusCode: 200 };
};

const getEmployeeErrors = async (date) => {
  const { result, statusCode } = await excecuteQueryAndHandleErrors('get_employee_errors.sql', Date(date));
  return { employee_errors: result, statusCode };
};

const getErrorExceptions = async () => {
  const { result, statusCode } = await excecuteQueryAndHandleErrors('get_employee_errors_exceptions.sql');
  return { exceptions: result, statusCode };
};

const addErrorException = async (policy, id, exception, req) => {
  await getPolicyInfo(policy); // Check if policy exists
  const { user } = await getMeService(req);
  const { result, statusCode } = await excecuteQueryAndHandleErrors('add_error_exception.sql', Exception(policy, id, exception, user.ID));
  return { result, statusCode };
};

const deleteErrorException = async (policy, id) => {
  await excecuteQueryAndHandleErrors('delete_error_exception.sql', Exception(policy, id));
  return { result: 'Successfully deleted report!', statusCode: 200 };
};

const updateErrorException = async (policy, id, exception) => {
  const { result, statusCode } = await excecuteQueryAndHandleErrors('updateErrorException.sql', Exception(policy, id, exception));
  return { result, statusCode };
};

module.exports = {
  getEmployeeErrors,
  getErrorExceptions,
  addErrorException,
  deleteErrorException,
  updateErrorException,
};
