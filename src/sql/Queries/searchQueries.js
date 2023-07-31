const DBConnection = require('../DBConnection');
const DB_CONFIG = require('../DBconfig');
const { searchField } = require('./params');

const search = async (search) => {
  const connection = new DBConnection(DB_CONFIG);
  return await connection.executeQuery('search.sql', searchField(search));
};

const searchAll = async () => {
  const connection = new DBConnection(DB_CONFIG);
  const result = await connection.executeQuery('searchAll.sql');
  return { searchResult: result, statusCode: 200 };
};

module.exports = {
  search,
  searchAll,
};
