/** @namespace result.recordset**/ /** @namespace result.recordsets**/
const { ConnectionPool } = require('mssql');
const AppError = require('../utils/AppError');
const logger = require('../logging/winstonSetup');
const loadSqlQueries = require('./sql_queries/loadSQLQueries');

module.exports = class DBConnection {
  constructor(config) {
    if (DBConnection._instance) {
      this.pool = new ConnectionPool(config);
      return DBConnection._instance;
    }
    this.pool = new ConnectionPool(config);
    DBConnection._instance = this;
  }

  async connect() {
    try {
      await this.pool.connect();
      logger.info('🔒 Connected to MSSQL database');
      console.log('🔒 Connected to MSSQL database');
    } catch (err) {
      throw new AppError('Error connecting to MSSQL database' + err.message, 500, 'error-connecting-to-db');
    }
  }
  async close() {
    try {
      await this.pool.close();
      console.log('🔒 Connection to MSSQL database closed');
      logger.info('🔒 Connection to MSSQL database closed');
    } catch (err) {
      throw new AppError('Error closing database connection' + err.message, 500, 'error-closing-db-connection');
    }
  }

  async executeQuery(query, params = [], multipleResultSets = false) {
    const query_name = query;
    try {
      const request = await this.pool.request();

      if (query.includes('.sql')) {
        query = await loadSqlQueries(query);
      }

      // Add parameters to the request
      params.forEach((param) => {
        request.input(param.name, param.value);
      });

      request.multiple = multipleResultSets;

      let result = await request.query(query);

      result = multipleResultSets === false ? result.recordset : result.recordsets;

      return result?.length === 1 ? result[0] : result?.length === 0 ? undefined : result;
    } catch (err) {
      logger.error(`Error executing query ${query_name} : ` + err.message);
      throw new AppError('Error executing query ' + err.message, 500, 'error-executing-query');
    }
  }

  async executeStoredProcedure(storedProcedure, params = []) {
    try {
      const request = await this.pool.request();

      // Add parameters to the request
      params.forEach((param) => {
        request.input(param.name, param.type, param.value);
      });

      const result = await request.execute(storedProcedure);

      return result.recordsets[0];
    } catch (err) {
      logger.error(`Error executing stored procedure ${storedProcedure} : ` + err.message);
      throw new AppError(`Error executing stored procedure ${storedProcedure} : ` + err.message, 500, 'error-executing-query');
    }
  }
};
