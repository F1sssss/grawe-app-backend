const DB_CONFIG = require('../DBconfig');
const DBConnection = require('../DBConnection');
const AppError = require('../../utils/AppError');
const { getPolicyInfo } = require('./PoliciesQueries');
const { Date, Exception } = require('../Queries/params');
const { getMeService } = require('../../services/userService');

const excecuteQueryAndHandleErrors = async (query, params = []) => {
  const connection = new DBConnection(DB_CONFIG.sql);
  const result = await connection.executeQuery(query, params);

  return { result: result === undefined ? {} : result, statusCode: 200 };
};

const getEmployeeErrors = async (date) => {
  const { result, statusCode } = await excecuteQueryAndHandleErrors('get_employee_errors.sql', Date(date));
  return { employee_errors: returnArray(result), statusCode };
};

const getErrorExceptions = async () => {
  const { result, statusCode } = await excecuteQueryAndHandleErrors('get_employee_errors_exceptions.sql');
  return { exceptions: returnArray(result), statusCode };
};

const addErrorException = async (policy, id, exception, req) => {
  if (Object.keys(await getPolicyInfo(policy)).length === 0) throw new AppError('Policy does not exist!', 404, 'error-policy-not-found');
  const { user } = await getMeService(req);
  const { result, statusCode } = await excecuteQueryAndHandleErrors('add_error_exception.sql', Exception(policy, id, exception, user.ID));
  return { result, statusCode };
};

const deleteErrorException = async (policy, id) => {
  await excecuteQueryAndHandleErrors('delete_error_exception.sql', Exception(policy, id));
  return { result: 'Successfully deleted exception!', statusCode: 200 };
};

function returnArray(error) {
  return Array.isArray(error) ? error : Object.keys(error).length > 0 ? [error] : [];
}

module.exports = {
  getEmployeeErrors,
  getErrorExceptions,
  addErrorException,
  deleteErrorException,
};
