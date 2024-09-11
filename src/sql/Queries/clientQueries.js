const DBConnection = require('../DBConnection');
const DB_CONFIG = require('../DBconfig');
const AppError = require('../../utils/AppError');
const { Client, Client_dateFrom_dateTo } = require('./params');

const excecuteQueryAndHandleErrors = async (queryFileName, params) => {
  const connection = new DBConnection(DB_CONFIG.sql);
  const client = await connection.executeQuery(queryFileName, params);

  if (!client && queryFileName === 'get_client_info.sql') {
    throw new AppError('Error during retrieving client!', 404, 'error-getting-client-not-found');
  }

  if (!client && queryFileName === 'get_client_all.sql') {
    throw new AppError('Error during retrieving client!', 404, 'error-getting-client-not-found');
  }

  return { client: client === undefined ? {} : client, statusCode: 200 };
};

const getClientInfo = async (id) => {
  const { client, statusCode } = await excecuteQueryAndHandleErrors('get_client_info.sql', Client(id));
  const policies = await excecuteQueryAndHandleErrors('get_client_policies.sql', Client(id));

  return {
    client: {
      ...client,
      policies: Array.isArray(policies['client']) ? policies['client']?.map((obj) => Object.values(obj)[0]) ?? [] : [policies['client']['bra_obnr']],
    },
    statusCode,
  };
};

const getClientHistory = async (id, dateFrom, dateTo) => {
  const { client, statusCode } = await excecuteQueryAndHandleErrors('get_client_history.sql', Client_dateFrom_dateTo(id, dateFrom, dateTo));
  return { client, statusCode };
};

const getClientAnalyticalInfo = async (id, dateFrom, dateTo) => {
  let { client, statusCode } = await excecuteQueryAndHandleErrors('get_client_all.sql', Client_dateFrom_dateTo(id, dateFrom, dateTo));
  if (!Array.isArray(client)) client = [client];
  const policies = await excecuteQueryAndHandleErrors('get_client_active_policies.sql', Client_dateFrom_dateTo(id, dateFrom, dateTo));

  const {
    klijent_bruto_polisirana_premija,
    klijent_neto_polisirana_premija,
    dani_kasnjenja,
    klijent_ukupna_potrazivanja,
    klijent_dospjela_potrazivanja,
  } = client[0];

  return {
    client: {
      klijent_bruto_polisirana_premija,
      klijent_neto_polisirana_premija,
      dani_kasnjenja,
      klijent_ukupna_potrazivanja,
      klijent_dospjela_potrazivanja,
      policies: Array.isArray(policies['client']) ? policies['client']?.map((obj) => Object.values(obj)[0]) ?? [] : [policies['client']['bra_obnr']],
    },
    statusCode,
  };
};

const getAllClientInfo = async (id, dateFrom, dateTo) => {
  const { client, statusCode } = await excecuteQueryAndHandleErrors('get_client_all.sql', Client_dateFrom_dateTo(id, dateFrom, dateTo));
  return { client, statusCode };
};

const getClientPolicyAnalticalInfo = async (id, dateFrom, dateTo) => {
  const { client, statusCode } = await excecuteQueryAndHandleErrors(
    'get_client_policy_analytical_info.sql',
    Client_dateFrom_dateTo(id, dateFrom, dateTo),
  );
  return { client, statusCode };
};

const getClientFinancialHistory = async (id, dateFrom, dateTo) => {
  const { client, statusCode } = await excecuteQueryAndHandleErrors('get_client_financial_history.sql', Client_dateFrom_dateTo(id, dateFrom, dateTo));
  return { clientFinHistory: client, statusCode };
};

const getClientFinancialInfo = async (id, dateFrom, dateTo) => {
  const { client, statusCode } = await excecuteQueryAndHandleErrors('get_client_financial_info.sql', Client_dateFrom_dateTo(id, dateFrom, dateTo));
  return { clientFinInfo: client, statusCode };
};

module.exports = {
  getClientInfo,
  getClientHistory,
  getClientAnalyticalInfo,
  getAllClientInfo,
  getClientPolicyAnalticalInfo,
  getClientFinancialHistory,
  getClientFinancialInfo,
};
