const DBConnection = require('../DBConnection');
const ReportQueries = require('../Queries/ReportsQueries');
const SQLParam = require('../SQLParam');
const sql = require('mssql');

test_sql = {
  server: 'localhost',
  database: 'GRAWE_TEST',
  user: 'sa',
  encrypt: false,
  password: 'Grawe123$',
  pool: {
    max: 20,
    min: 0,
    idleTimeoutMillis: 300000,
  },
};
jest.setTimeout(300000000);
describe('Reports queries tests', () => {
  beforeAll(() => {
    connection = new DBConnection(test_sql);
  });

  it('should connect to the test database', async () => {
    const consoleSpy = jest.spyOn(console, 'log');
    await connection.connect();
    expect(consoleSpy).toHaveBeenCalledWith('🔒 Connected to MSSQL database');
    consoleSpy.mockRestore();
  });

  it('should get all reports', async () => {
    const { reports } = await ReportQueries.getReports();
    expect(reports.length).toBeGreaterThan(0);
  });

  //Get Report By id Tests

  it('should throw an error that report does not exist', async () => {
    try {
      const { report_info, report_params } = await ReportQueries.getReportById(15252332523);
    } catch (error) {
      expect(error.statusCode).toBe(404);
    }
  });

  it('get report info by id', async () => {
    const { report_info, report_params } = await ReportQueries.getReportById(5);
    expect(report_info.report_id).toBe(5);
    expect(report_params[0].order).toBe(1);
  });

  //Get Report By Name Tests

  it('should get report info by name', async () => {
    const { report_info, report_params } = await ReportQueries.getReportByName('Dani Kasnjenja Polisa');

    expect(report_info.report_id).toBe(6);
    expect(report_params[0].order).toBe(1);
  });

  //Search Stored Procedure Tests
  it('should return the name of the stored procedure', async () => {
    const { procedure_info } = await ReportQueries.getProcedureInfo('gr_kanal_prodaje');
    expect(procedure_info.procedure_name).toBe('gr_kanal_prodaje');
  });

  it('should return error if procedure does not exist', async () => {
    try {
      const { statusCode } = await ReportQueries.getProcedureInfo('gr_kanal_prodaje1');
    } catch (error) {
      expect(error.statusCode).toBe(404);
    }
  });

  it('should get param values', async () => {
    const { param_values } = await ReportQueries.getParamValues(251252050, 5, '@KanalProdaje', 2);
    expect(param_values.result).toBeDefined();
  });

  it('should throw an error that the param doesnt have sql', async () => {
    try {
      await ReportQueries.getParamValues(251252050, 5, '@datum', 1);
    } catch (error) {
      expect(error.statusMessage).toBe('error-param-query-empty');
    }
  });

  it('should run the report', async () => {
    const { report_info, report_params } = await ReportQueries.getReportById(6);
    const { reportResult, statusCode } = await ReportQueries.executeReport(report_info['procedure_name'], [
      new SQLParam('DatumIzvjestaja', '30.09.2022', sql.VarChar),
      new SQLParam('Polisa', 7001179, sql.Int),
    ]);
    expect(reportResult.length).toBeGreaterThan(0);
  });

  it('should ythrow an error for create report', async () => {
    const policy = {
      procedure_info: {
        report_id: 5,
        report_name: 'Kanal Prodaje',
        procedure_id: 53015370,
        procedure_name: 'gr_kanal_prodaje',
      },
      procedure_params: [
        {
          order: 1,
          param_name: '@datum',
          type: 'VARCHAR',
          length: 10,
          sql_query: '',
        },
        {
          order: 2,
          param_name: '@KanalProdaje',
          type: 'INT',
          length: 4,
          sql_query: 'select 1',
        },
      ],
      new_report_name: '',
    };

    try {
      const {
        createdReport: { report_info: report_id },
        statusCode,
      } = await ReportQueries.createReport(policy);
    } catch (error) {
      expect(error.statusCode).toBe(404);
    }
  });

  it('should create a report', async () => {
    const policy = {
      procedure_info: {
        report_id: 5,
        report_name: 'Kanal Prodaje',
        procedure_id: 53015370,
        procedure_name: 'gr_kanal_prodaje',
      },
      procedure_params: [
        {
          order: 1,
          param_name: '@datum',
          type: 'VARCHAR',
          length: 10,
          sql_query: '',
        },
        {
          order: 2,
          param_name: '@KanalProdaje',
          type: 'INT',
          length: 4,
          sql_query: 'select 1',
        },
      ],
      new_report_name: 'testingReport',
    };

    const {
      createdReport: { report_info: report_id },
      statusCode,
    } = await ReportQueries.createReport(policy);
    expect(report_id).toBeDefined();
  });

  it('should throw an error for update report that name already exists', async () => {
    const updated_report = {
      report_info: {
        report_id: 5,
        report_name: 'testingReport',
        procedure_id: 251252050,
        procedure_name: 'gr_kanal_prodaje',
      },
      report_params: [
        {
          order: 1,
          param_name: '@datum',
          type: 'VARCHAR',
          length: 10,
          sql_query: '',
        },
        {
          order: 2,
          param_name: '@KanalProdaje',
          type: 'INT',
          length: 4,
          sql_query: 'select 1 as test',
        },
      ],
    };

    try {
      const {
        updatedReport: { report_info: report_id },
        statusCode,
      } = await ReportQueries.updateReport(5, updated_report);
    } catch (error) {
      expect(error.statusCode).toBe(404);
    }
  });

  it('should update a report name', async () => {
    const updated_report = {
      report_info: {
        report_id: 5,
        report_name: 'Updateovani report',
        procedure_id: 251252050,
        procedure_name: 'gr_kanal_prodaje',
      },
      report_params: [
        {
          order: 1,
          param_name: '@datum',
          type: 'VARCHAR',
          length: 10,
          sql_query: '',
        },
        {
          order: 2,
          param_name: '@KanalProdaje',
          type: 'INT',
          length: 4,
          sql_query: 'select 1 as test',
        },
      ],
    };

    const {
      report_info: { report_id },
      report_params,
    } = await ReportQueries.getReportByName('testingReport');

    const { updatedReport, statusCode } = await ReportQueries.updateReport(report_id, updated_report);

    expect(updatedReport.report_info.report_name).toBe('Updateovani report');
  });

  it('should throw an error that report doesnt exist', async () => {
    try {
      const { statusCode } = await ReportQueries.deleteReport(826371763912);
    } catch (error) {
      expect(error.statusCode).toBe(404);
    }
  });

  it('should delete a report', async () => {
    const { report_info, report_params } = await ReportQueries.getReportByName('Updateovani report');
    const { message } = await ReportQueries.deleteReport(report_info.report_id);

    try {
      const { statusCode } = await ReportQueries.getReportByName('Updateovani report');
    } catch (error) {
      expect(error.statusCode).toBe(404);
    }
  });

  it('should close the connection', async () => {
    const consoleSpy = jest.spyOn(console, 'log');
    await connection.close();
    expect(consoleSpy).toHaveBeenCalledWith('🔒 Connection to MSSQL database closed');
    consoleSpy.mockRestore();
  });
});
