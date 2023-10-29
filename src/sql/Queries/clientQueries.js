const DBConnection = require('../DBConnection');
const DB_CONFIG = require('../DBconfig');
const AppError = require('../../utils/AppError');
const { Client, Client_dateFrom_dateTo } = require('./params');

const excecuteQueryAndHandleErrors = async (queryFileName, params) => {
  const connection = new DBConnection(DB_CONFIG.sql);
  const client = await connection.executeQuery(queryFileName, params);

  if (!client && queryFileName === 'getclientInfo.sql') {
    throw new AppError('Error during retrieving client', 404, 'error-getting-client-not-found');
  }

  return { client: client === undefined ? {} : client, statusCode: 200 };
};

const getClientInfo = async (id) => {
  const { client, statusCode } = await excecuteQueryAndHandleErrors('getclientInfo.sql', Client(id));
  const policies = await excecuteQueryAndHandleErrors('getclientPolicies.sql', Client(id));

  return {
    client: {
      ...client,
      policies: Array.isArray(policies['client']) ? policies['client']?.map((obj) => Object.values(obj)[0]) ?? [] : [policies['client']['bra_obnr']],
    },
    statusCode,
  };
};

const getClientHistory = async (id, dateFrom, dateTo) => {
  const { client, statusCode } = await excecuteQueryAndHandleErrors('getClientHistory.sql', Client_dateFrom_dateTo(id, dateFrom, dateTo));
  return { client, statusCode };
};

const getClientAnalyticalInfo = async (id, dateFrom, dateTo) => {
  let { client, statusCode } = await excecuteQueryAndHandleErrors('getClientAll.sql', Client_dateFrom_dateTo(id, dateFrom, dateTo));
  if (!Array.isArray(client)) client = [client];
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
    },
    statusCode,
  };
};

const getAllClientInfo = async (id, dateFrom, dateTo) => {
  const { client, statusCode } = await excecuteQueryAndHandleErrors('getClientAll.sql', Client_dateFrom_dateTo(id, dateFrom, dateTo));
  return { client, statusCode };
};

const getClientPolicyAnalticalInfo = async (id, dateFrom, dateTo) => {
  const { client, statusCode } = await excecuteQueryAndHandleErrors('getClientPolicyAnalticalInfo.sql', Client_dateFrom_dateTo(id, dateFrom, dateTo));
  return { client, statusCode };
};

module.exports = {
  getClientInfo,
  getClientHistory,
  getClientAnalyticalInfo,
  getAllClientInfo,
  getClientPolicyAnalticalInfo,
};
