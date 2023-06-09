/** @namespace result.recordset**/
const { ConnectionPool } = require('mssql');

module.exports = class DBConnection {
  constructor(config) {
    this.pool = new ConnectionPool(config);
  }

  async connect() {
    try {
      await this.pool.connect();
    } catch (err) {
      console.log(err);
      throw err;
    }
  }
  async close() {
    try {
      await this.pool.close();
    } catch (err) {
      console.log(
        'Error closing connection to MSSQL database (DBConnection.js)'
      );
      console.log(err);
      throw err;
    }
  }

  async executeQuery(query, params = []) {
    try {
      await this.connect();

      const request = await this.pool.request();
      // Add parameters to the request
      params.forEach((param) => {
        request.input(param.name, param.value);
      });

      let result = await request.query(query);
      await this.close();
      result = result.recordset;
      return result[0];
    } catch (err) {
      console.log('Error executing query');
      console.log(err);
      throw err;
    }
  }
};
