const sql = require('mssql');
/** @namespace  sql.Int**/
/** @namespace sql.VarChar **/
const DBConnection = require('../DBConnection');
const DB_CONFIG = require('../DBconfig');
const SQLParam = require('../SQLParam');
const AppError = require('../../utils/AppError');
const loadSQLQueries = require('../sql_queries/loadSQL');

const getPolicyInfo = async (id) => {
  const connection = new DBConnection(DB_CONFIG.sql);
  const query = await loadSQLQueries('policy.sql');

  if (!query)
    throw new AppError(
      'Error loading policy query',
      500,
      'error-getting-policyinfo-query'
    );

  const policies = await connection.executeQuery(query, [
    new SQLParam('policy', id, sql.Int)
  ]);

  if (!policies) {
    throw new AppError(
      'Policy not found by id!',
      404,
      'error-getting-policyinfo-query'
    );
  }

  return { policies, statusCode: 200 };
};

const getPolicyHistory = async (id) => {
  const policyHistoryQuery = await loadSQLQueries('getPolicyHistory.sql');
  const connection = new DBConnection(DB_CONFIG.sql);
  const policy = await connection.executeQuery(policyHistoryQuery, [
    new SQLParam('polisa', id, sql.Int)
  ]);
  if (!policy) {
    throw new AppError(
      'Error during retrieving policy history',
      404,
      'error-getting-policy-history-query'
    );
  }

  return { policy, statusCode: 200 };
};

module.exports = {
  getPolicyInfo,
  getPolicyHistory
};
