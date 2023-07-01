const DBConnection = require('../DBConnection');
const DB_CONFIG = require('../DBconfig');
const AppError = require('../../utils/AppError');
const loadSQLQueries = require('../sql_queries/loadSQL');
const { Client, Client_dateFrom_dateTo } = require('./params');

const excecuteClientQueryTemplate = async (queryFileName, params, can_be_empty = false) => {
  const query = await loadSQLQueries(queryFileName);
  const connection = new DBConnection(DB_CONFIG.sql);

  const client = await connection.executeQuery(query, params);

  if (!client && !can_be_empty) {
    throw new AppError('Error during retrieving client', 404, 'error-getting-client-not-found');
  }

  return { client: client === undefined ? {} : client, statusCode: 200 };
};

const getClientInfo = async (id) => {
  return ({ client, statusCode } = await excecuteClientQueryTemplate('getclientInfo.sql', Client(id)));
};

const getClientHistory = async (id, dateFrom, dateTo) => {
  const { client, statusCode } = await excecuteClientQueryTemplate('getClientHistory.sql', Client_dateFrom_dateTo(id, dateFrom, dateTo), true);
  return { client, statusCode };
};

const getClientAnalyticalInfo = async (id, dateFrom, dateTo) => {
  return ({ client, statusCode } = await excecuteClientQueryTemplate(
    'getClientAnalyticalInfo.sql',
    Client_dateFrom_dateTo(id, dateFrom, dateTo),
    true,
  ));
};

module.exports = {
  getClientInfo,
  getClientHistory,
  getClientAnalyticalInfo,
};
