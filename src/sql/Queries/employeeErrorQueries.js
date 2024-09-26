const { executeQueryAndHandleErrors, returnArray } = require('../executeQuery');
const AppError = require('../../utils/AppError');
const { getPolicyInfo } = require('./policiesQueries');
const { Date, Exception } = require('../Queries/params');
const { getMeService } = require('../../services/userService');

const getEmployeeErrors = async (date) => {
  const { data, statusCode } = await executeQueryAndHandleErrors('get_employee_errors.sql', Date(date));
  return { employee_errors: returnArray(data), statusCode };
};

const getErrorExceptions = async () => {
  const { data, statusCode } = await executeQueryAndHandleErrors('get_employee_errors_exceptions.sql');
  return { exceptions: returnArray(data), statusCode };
};

const addErrorException = async (policy, id, exception, req) => {
  if (Object.keys(await getPolicyInfo(policy)).length === 0) throw new AppError('Policy does not exist!', 404, 'error-policy-not-found');
  const { user } = await getMeService(req);
  const { data, statusCode } = await executeQueryAndHandleErrors('add_error_exception.sql', Exception(policy, id, exception, user.ID));
  return { result: data, statusCode };
};

const deleteErrorException = async (policy, id) => {
  await executeQueryAndHandleErrors('delete_error_exception.sql', Exception(policy, id));
  return { result: 'Successfully deleted exception!', statusCode: 200 };
};

module.exports = {
  getEmployeeErrors,
  getErrorExceptions,
  addErrorException,
  deleteErrorException,
};
