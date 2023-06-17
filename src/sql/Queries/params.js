const sql = require('mssql');
const SQLParam = require('../SQLParam');
const AppError = require('../../utils/AppError');

const Policy = (id) => {
  return new SQLParam('policy', id, sql.Int);
};

const Report = (id) => {
  return [new SQLParam('report', id, sql.Int)];
};

const Policy_dateFrom_dateTo = (policy, dateFrom, dateTo) => {
  return [new SQLParam('policy', policy, sql.Int), new SQLParam('dateFrom', dateFrom, sql.VarChar), new SQLParam('dateTo', dateTo, sql.VarChar)];
};

const Policy_Date = (policy, date) => {
  return [new SQLParam('policy', policy, sql.Int), new SQLParam('date', date, sql.VarChar)];
};

const UserSignup = (username, password, name, last_name, email, date_of_birth, verification_code) => {
  return [
    new SQLParam('username', username, sql.VarChar),
    new SQLParam('password', password, sql.VarChar),
    new SQLParam('name', name, sql.VarChar),
    new SQLParam('last_name', last_name, sql.VarChar),
    new SQLParam('email', email, sql.VarChar),
    new SQLParam('DOB', date_of_birth, sql.VarChar),
    new SQLParam('verification_code', verification_code, sql.Int),
  ];
};

const ReportParams = (reportParams, InputParams) => {
  if (reportParams.length !== Object.keys(InputParams).length)
    throw new AppError('Error during retrieving reports', 404, 'error-getting-reports-query');

  let queryParams = [];
  reportParams.forEach((param, index) => {
    queryParams.push(new SQLParam(param.param_name.slice(1), Object.values(InputParams)[index], sql[param.type]));
  });

  return queryParams;
};

module.exports = {
  Policy,
  Policy_dateFrom_dateTo,
  Policy_Date,
  UserSignup,
  Report,
  ReportParams,
};
