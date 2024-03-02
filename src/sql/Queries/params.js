//Params for queries and stored procedures

const sql = require('mssql');
/** @namespace sql.Int * **/
/** @namespace sql.VarChar * **/

const SQLParam = require('../SQLParam');
const AppError = require('../../utils/AppError');

const Policy = (id) => {
  return new SQLParam('policy', id, sql.Int);
};

const UserMigration = (username, password) => {
  return [new SQLParam('username', username, sql.VarChar), new SQLParam('password', password, sql.VarChar)];
};

const searchField = (search) => {
  return [new SQLParam('search', search, sql.VarChar)];
};

const Client = (id) => {
  return [new SQLParam('id', id, sql.VarChar)];
};

const Client_dateFrom_dateTo = (id, dateFrom, dateTo) => {
  return [new SQLParam('id', id, sql.VarChar), new SQLParam('dateFrom', dateFrom, sql.VarChar), new SQLParam('dateTo', dateTo, sql.VarChar)];
};
const Report = (id) => {
  return [new SQLParam('report', id, sql.Int)];
};

const ReportId = (id) => {
  return [new SQLParam('id', id, sql.Int)];
};

const StoredProcedure = (procedure_name) => {
  return [new SQLParam('procedure_name', procedure_name, sql.VarChar)];
};

const NewReport = (new_report_name, procedure_id) => {
  return [new SQLParam('new_report_name', new_report_name, sql.VarChar), new SQLParam('procedure_id', procedure_id, sql.Int)];
};

const NewParam = (procedure_id, report_id, order, param_name, sql_query) => {
  return [
    new SQLParam('procedure_id', procedure_id, sql.Int),
    new SQLParam('report_id', report_id, sql.Int),
    new SQLParam('order', order, sql.Int),
    new SQLParam('param_name', param_name, sql.VarChar),
    new SQLParam('sql_query', sql_query, sql.VarChar),
  ];
};

const Param = (procedure_id, report_id, param_name, order) => {
  return [
    new SQLParam('procedure_id', procedure_id, sql.Int),
    new SQLParam('report_id', report_id, sql.Int),
    new SQLParam('param_name', param_name, sql.VarChar),
    new SQLParam('order', order, sql.Int),
  ];
};

const Policy_dateFrom_dateTo = (policy, dateFrom, dateTo) => {
  return [new SQLParam('policy', policy, sql.Int), new SQLParam('dateFrom', dateFrom, sql.VarChar), new SQLParam('dateTo', dateTo, sql.VarChar)];
};

const Policy_Date = (policy, date) => {
  return [new SQLParam('policy', policy, sql.Int), new SQLParam('date', date, sql.VarChar)];
};

const ReportProcedure = (report_id, procedure_id) => {
  return [new SQLParam('id', report_id, sql.Int), new SQLParam('procedure_id', procedure_id, sql.Int)];
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
    queryParams.push(new SQLParam(param['param_name'].slice(1), Object.values(InputParams)[index], sql[param.type]));
  });

  return queryParams;
};

const ReportName = (id, report_name) => {
  return [new SQLParam('id', id, sql.Int), new SQLParam('report_name', report_name, sql.VarChar)];
};

const Date = (date) => {
  return [new SQLParam('date', date, sql.VarChar)];
};

const Exception = (policy, id, exception) => {
  return [new SQLParam('policy', policy, sql.Int), new SQLParam('id', id, sql.Int), new SQLParam('exception', exception, sql.VarChar)];
};

const Permission = (permission) => {
  return [
    new SQLParam('route', permission.route, sql.VarChar),
    new SQLParam('visibility', permission.visibility, sql.VarChar),
    new SQLParam('method', permission.method, sql.VarChar),
    new SQLParam('name', permission.name, sql.VarChar),
    new SQLParam('description', permission.description, sql.VarChar),
  ];
};

const PermissionUpdate = (id, permission) => {
  return [
    new SQLParam('id', id, sql.Int),
    new SQLParam('name', permission.name, sql.VarChar),
    new SQLParam('description', permission.description, sql.VarChar),
  ];
};

const PermissionGroupID = (id) => {
  return [new SQLParam('id', id, sql.Int)];
};

const AccessControl = (route, user, id) => {
  return [new SQLParam('route', route, sql.VarChar), new SQLParam('user', user, sql.Int), new SQLParam('id', id, sql.VarChar)];
};

const PermissionGroupName = (name) => {
  return [new SQLParam('name', name, sql.VarChar)];
};

const PermissionRights = (id, group, read, write) => {
  return [
    new SQLParam('id', id, sql.Int),
    new SQLParam('group', group, sql.Int),
    new SQLParam('read', read, sql.Int),
    new SQLParam('write', write, sql.Int),
  ];
};

const PermissionGroup = (id, name) => {
  return [new SQLParam('id', id, sql.Int), new SQLParam('name', name, sql.VarChar)];
};

const PermissionID = (id) => {
  return [new SQLParam('id', id, sql.Int)];
};

const PermissionGroupPairing = (id_permission_group, id_permission) => {
  return [new SQLParam('id_permission_group', id_permission_group, sql.Int), new SQLParam('id_permission', id_permission, sql.Int)];
};

const PermissionProperties = (id_permission, id_permission_group) => {
  return [new SQLParam('id_permission', id_permission, sql.Int), new SQLParam('id_permission_group', id_permission_group, sql.Int)];
};

module.exports = {
  Policy,
  Policy_dateFrom_dateTo,
  Policy_Date,
  UserSignup,
  Report,
  ReportParams,
  NewReport,
  NewParam,
  StoredProcedure,
  Param,
  ReportProcedure,
  ReportName,
  Client,
  Client_dateFrom_dateTo,
  searchField,
  Date,
  Exception,
  ReportId,
  Permission,
  AccessControl,
  PermissionGroupID,
  PermissionGroupName,
  PermissionGroup,
  PermissionID,
  PermissionUpdate,
  PermissionRights,
  PermissionGroupPairing,
  PermissionProperties,
  UserMigration,
};
