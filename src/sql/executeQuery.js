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

function returnArray(data) {
  return Array.isArray(data) ? data : Object.keys(data).length === 0 ? [] : [data];
}

module.exports = {
  executeQueryAndHandleErrors,
  returnArray,
};
