const sql = require('mssql');

module.exports = class DBConnection {
  constructor(config) {
    this.config = config;
    this.pool = new sql.ConnectionPool(this.config);
  }

  async connect() {
    try {
      await this.pool.connect();
      console.log('Connected to MSSQL database');
    } catch (err) {
      console.log('Error connecting to MSSQL database (DBConnect.js))');
      console.log(err);
      throw err;
    }
  }
  async close() {
    try {
      await this.pool.close();
      console.log('Connection to MSSQL database closed');
    } catch (err) {
      console.log('Error closing connection to MSSQL database (DBConnect.js)');
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

      const result = await request.query(query);
      console.log('Query executed successfully');
      //console.log(result.recordset);
      await this.close();
      return result.recordset;
    } catch (err) {
      console.log('Error executing query');
      console.log(err);
      throw err;
    }
  }
};
