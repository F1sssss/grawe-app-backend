/** @namespace  sql.Int**/
/** @namespace sql.VarChar **/
const DBConnection = require('../DBConnection');
const DB_CONFIG = require('../DBconfig');
const AppError = require('../../utils/AppError');
const loadSQLQueries = require('../sql_queries/loadSQL');
const { Policy, Policy_dateFrom_dateTo } = require('./params');

const excecutePolicyQueryTemplate = async (queryFileName, params, can_be_empty = false) => {
  const query = await loadSQLQueries(queryFileName);
  const connection = new DBConnection(DB_CONFIG.sql);
  const policy = await connection.executeQuery(query, params);
  if (!policy && !can_be_empty) {
    throw new AppError('Error during retrieving policy', 404, 'error-getting-policy-not-found');
  }
  return { policy: policy === undefined ? {} : policy, statusCode: 200 };
};

const getPolicyInfo = async (id) => {
  return ({ policy, statusCode } = await excecutePolicyQueryTemplate('policyInfo.sql', [Policy(id)]));
};

const getPolicyHistory = async (id, dateFrom, dateTo) => {
  return ({ policy, statusCode } = await excecutePolicyQueryTemplate('getPolicyHistory.sql', Policy_dateFrom_dateTo(id, dateFrom, dateTo), true));
};

const getPolicyAnalyticalInfo = async (id, dateFrom, dateTo) => {
  return ({ policy, statusCode } = await excecutePolicyQueryTemplate(
    'getPolicyAnalyticalInfo.sql',
    Policy_dateFrom_dateTo(id, dateFrom, dateTo),
    true,
  ));
};

module.exports = {
  getPolicyInfo,
  getPolicyHistory,
  getPolicyAnalyticalInfo,
};
