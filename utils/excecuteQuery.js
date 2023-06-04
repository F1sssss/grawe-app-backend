const DBConfig = require('../sql/DBconfig');
const sql = require('mssql');
const DBConnection = require('../sql/DBConnect');
const { request } = require('express');

async function executeQuery(query, params = []) {
  try {
    const { pool } = await DBConnection.DBConnection(DBConfig.sql);

    const request = new sql.Request(pool);

    params.forEach((param) => {
      request.input(param.name, param.type, param.value);
    });

    const result = await request.query(query);

    pool.release();

    return result.recordset;
  } catch (err) {
    console.log('Error executing query');
    console.log(err);
  }
}

module.exports = executeQuery;
