const DBConnection = require('./DBConnection');
const DB_CONFIG = require('./DBconfig');

const executeQueryAndHandleErrors = async (queryFileName, params = [], multiple = false, type = 'query') => {
  const connection = new DBConnection(DB_CONFIG.sql);

  const data =
    type === 'query'
      ? await connection.executeQuery(queryFileName, params, multiple)
      : await connection.executeStoredProcedure(queryFileName, params);

  return { data: data === undefined ? {} : data, statusCode: 200 };
};

const returnArray = (data) => {
  if (!data) {
    return [];
  }
  return Array.isArray(data) ? data : [data];
};

module.exports = {
  executeQueryAndHandleErrors,
  returnArray,
};
