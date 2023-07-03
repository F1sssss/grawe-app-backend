const DBConnection = require('../DBConnection');
const DB_CONFIG = require('../DBconfig');
const { searchField } = require('./params');

const searchQueries = async (search) => {
  const connection = new DBConnection(DB_CONFIG);
  return await connection.executeQuery('searchAll.sql', searchField(search));
};

module.exports = {
  searchQueries,
};
