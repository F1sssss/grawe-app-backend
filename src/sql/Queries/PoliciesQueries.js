/** @namespace  sql.Int**/
/** @namespace sql.VarChar **/
const DBConnection = require('../DBConnection');
const DB_CONFIG = require('../DBconfig');
const { Policy, Policy_dateFrom_dateTo } = require('./params');

const excecuteQueryAndHandleErrors = async (queryFileName, params) => {
  const connection = new DBConnection(DB_CONFIG.sql);
  const policy = await connection.executeQuery(queryFileName, params);

  return { policy: policy === undefined ? {} : policy, statusCode: 200 };
};

const getPolicyInfo = async (id) => {
  return ({ policy, statusCode } = await excecuteQueryAndHandleErrors('get_policy_info.sql', [Policy(id)]));
};

const getPolicyHistory = async (id, dateFrom, dateTo) => {
  const { policy, statusCode } = await excecuteQueryAndHandleErrors('get_policy_history.sql', Policy_dateFrom_dateTo(id, dateFrom, dateTo));
  return { policy: returnArray(policy), statusCode };
};

const getPolicyAnalyticalInfo = async (id, dateFrom, dateTo) => {
  return ({ policy, statusCode } = await excecuteQueryAndHandleErrors(
    'get_policy_analytical_info.sql',
    Policy_dateFrom_dateTo(id, dateFrom, dateTo),
  ));
};

const getPolicyExcelInfo = async (id, dateFrom, dateTo) => {
  return ({ policy, statusCode } = await excecuteQueryAndHandleErrors('get_policy_excel_info.sql', Policy_dateFrom_dateTo(id, dateFrom, dateTo)));
};

function returnArray(client) {
  return Array.isArray(client) ? client : Object.keys(client).length > 0 ? [client] : [];
}

module.exports = {
  getPolicyInfo,
  getPolicyHistory,
  getPolicyAnalyticalInfo,
  getPolicyExcelInfo,
};
