const { Client, Client_dateFrom_dateTo, Client_dateFrom_dateTo_ZK_AO } = require('./params');
const { executeQueryAndHandleErrors, returnArray } = require('../executeQuery');

const getClientInfo = async (id) => {
  const { data, statusCode } = await executeQueryAndHandleErrors('get_client_info.sql', Client(id));

  return {
    client: {
      ...data,
    },
    statusCode,
  };
};

const getClientHistory = async (id, dateFrom, dateTo) => {
  const { data, statusCode } = await executeQueryAndHandleErrors('get_client_history.sql', Client_dateFrom_dateTo(id, dateFrom, dateTo));
  return {
    client: returnArray(data),
    statusCode,
  };
};

const getClientAnalyticalInfo = async (id, dateFrom, dateTo) => {
  let { data, statusCode } = await executeQueryAndHandleErrors('get_client_analytical_info.sql', Client_dateFrom_dateTo(id, dateFrom, dateTo));
  data = returnArray(data);
  const policies = await executeQueryAndHandleErrors('get_client_active_policies.sql', Client_dateFrom_dateTo(id, dateFrom, dateTo));

  const {
    klijent_bruto_polisirana_premija,
    klijent_neto_polisirana_premija,
    dani_kasnjenja,
    klijent_ukupna_potrazivanja,
    klijent_dospjela_potrazivanja,
  } = data[0] ?? {};

  return {
    client: {
      klijent_bruto_polisirana_premija,
      klijent_neto_polisirana_premija,
      dani_kasnjenja,
      klijent_ukupna_potrazivanja,
      klijent_dospjela_potrazivanja,
      policies:
        Array.isArray(policies['data']) && policies['data'] !== null && policies['data'] !== undefined
          ? policies['data']?.map((obj) => Object.values(obj)[0]) ?? []
          : [],
    },
    statusCode,
  };
};

const getAllClientInfo = async (id, dateFrom, dateTo) => {
  const { data, statusCode } = await executeQueryAndHandleErrors('get_client_all.sql', Client_dateFrom_dateTo(id, dateFrom, dateTo));
  return { client: returnArray(data), statusCode };
};

const getAllClientInfoFiltered = async (id, dateFrom, dateTo, ZK, AO) => {
  const { data, statusCode } = await executeQueryAndHandleErrors(
    'get_client_all_filtered.sql',
    Client_dateFrom_dateTo_ZK_AO(id, dateFrom, dateTo, ZK, AO),
  );
  return { client: returnArray(data), statusCode };
};

const getClientPolicyAnalticalInfo = async (id, dateFrom, dateTo) => {
  const { data, statusCode } = await executeQueryAndHandleErrors(
    'get_client_policy_analytical_info.sql',
    Client_dateFrom_dateTo(id, dateFrom, dateTo),
  );
  return { client: data, statusCode };
};

const getClientFinancialHistory = async (id, dateFrom, dateTo, ZK, AO) => {
  const { data, statusCode } = await executeQueryAndHandleErrors(
    'get_client_financial_history.sql',
    Client_dateFrom_dateTo_ZK_AO(id, dateFrom, dateTo, ZK, AO),
  );
  return { clientFinHistory: returnArray(data), statusCode };
};

const getClientFinancialInfo = async (id, dateFrom, dateTo, ZK, AO) => {
  const { data, statusCode } = await executeQueryAndHandleErrors(
    'get_client_financial_info.sql',
    Client_dateFrom_dateTo_ZK_AO(id, dateFrom, dateTo, ZK, AO),
  );
  return { clientFinInfo: data.ukupno_nedospjelo === null && data.ukupno_dospjelo === null ? {} : data, statusCode };
};

module.exports = {
  getClientInfo,
  getClientHistory,
  getClientAnalyticalInfo,
  getAllClientInfo,
  getClientPolicyAnalticalInfo,
  getClientFinancialHistory,
  getClientFinancialInfo,
  getAllClientInfoFiltered,
};
