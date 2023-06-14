/** @namespace result.recordset**/
const { ConnectionPool, Request } = require('mssql');
const AppError = require('../utils/AppError');
module.exports = class DBConnection {
  constructor(config) {
    if (DBConnection._instance) {
      return DBConnection._instance;
    }
    this.pool = new ConnectionPool(config);
    DBConnection._instance = this;
  }

  async connect() {
    try {
      await this.pool.connect();
      console.log('🔒 Connected to MSSQL database');
    } catch (err) {
      throw new AppError(
        'Error connecting to MSSQL database' + err.message,
        500,
        'error-connecting-to-db'
      );
    }
  }
  async close() {
    try {
      await this.pool.close();
      console.log('🔒 Connection to MSSQL database closed');
    } catch (err) {
      throw new AppError(
        'Error closing database connection' + err.message,
        500,
        'error-closing-db-connection'
      );
    }
  }

  async executeQuery(query, params = []) {
    try {
      const request = await this.pool.request();

      // Add parameters to the request
      params.forEach((param) => {
        request.input(param.name, param.value);
      });

      let result = await request.query(query);

      result = result.recordset;

      return result.length === 1 ? result[0] : result;
    } catch (err) {
      throw new AppError(
        'Error executing query' + err.message,
        500,
        'error-executing-query'
      );
    }
  }

  async executeStreamQuery(query, params = []) {
    try {
      const request = new Request(this.pool);
      request.stream = true;

      // Add parameters to the request
      params.forEach((param) => {
        request.input(param.name, param.value);
      });

      request.query(query);

      request.on('recordset', (columns) => {
        console.log(columns);
      });

      request.on('row', (row) => {
        console.log(row);
      });

      request.on('done', (result) => {
        console.log('done', result);
      });

      return true;
    } catch (err) {
      throw new AppError(
        'Error executing query' + err.message,
        500,
        'error-executing-query'
      );
    }
  }
};
