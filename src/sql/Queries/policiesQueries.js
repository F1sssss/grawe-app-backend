const { executeQueryAndHandleErrors, returnArray } = require('../executeQuery');
const { Policy, Policy_dateFrom_dateTo } = require('./params');

const getPolicyInfo = async (id) => {
  const { data, statusCode } = await executeQueryAndHandleErrors('get_policy_info.sql', [Policy(id)]);
  return { policy: data, statusCode };
};

const getPolicyHistory = async (id, dateFrom, dateTo) => {
  const { data, statusCode } = await executeQueryAndHandleErrors('get_policy_history.sql', Policy_dateFrom_dateTo(id, dateFrom, dateTo));
  return { policy: returnArray(data), statusCode };
};

const getPolicyAnalyticalInfo = async (id, dateFrom, dateTo) => {
  const { data, statusCode } = await executeQueryAndHandleErrors('get_policy_analytical_info.sql', Policy_dateFrom_dateTo(id, dateFrom, dateTo));
  return { policy: data, statusCode };
};

const getPolicyExcelInfo = async (id, dateFrom, dateTo) => {
  const { data, statusCode } = await executeQueryAndHandleErrors('get_policy_excel_info.sql', Policy_dateFrom_dateTo(id, dateFrom, dateTo));
  return { policy: data, statusCode };
};

module.exports = {
  getPolicyInfo,
  getPolicyHistory,
  getPolicyAnalyticalInfo,
  getPolicyExcelInfo,
};
