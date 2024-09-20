const DBConnection = require('../../sql/DBConnection');
const ReportQueries = require('../../sql/Queries/reportsQueries');

sql_config = {
  server: '192.168.1.217',
  database: 'GRAWE_WEBAPP_TEST',
  user: 'sa',
  encrypt: false,
  password: 'Grawe123$',
  pool: {
    max: 20,
    min: 0,
    idleTimeoutMillis: 300000,
  },
};

describe('Report queries tests', () => {
  let procedura_id;
  let params;
  let report_id;

  beforeAll(() => {
    connection = new DBConnection(sql_config);
    jest.setTimeout(50000000);
  });

  it('should connect to the test database', async () => {
    const consoleSpy = jest.spyOn(console, 'log');
    await connection.connect();
    expect(consoleSpy).toHaveBeenCalledWith('🔒 Connected to MSSQL database');
    consoleSpy.mockRestore();
  }, 50000);

  it('should find procedure info', async () => {
    const { procedure_info, procedure_params, statusCode } = await ReportQueries.getProcedureInfo('test_procedur');
    expect(statusCode).toBe(200);
    expect(procedure_info).toBeDefined();
    expect(procedure_params).toBeDefined();

    procedura_id = procedure_info.procedure_id;
    params = procedure_params;
  });

  it('should return empty object when finding procedure info', async () => {
    const { procedure_info, procedure_params, statusCode } = await ReportQueries.getProcedureInfo('blabla');
    expect(statusCode).toBe(200);
    expect(procedure_info).toStrictEqual({});
    expect(procedure_params).toStrictEqual([]);
  });

  it('should return only 1 procedure when searching', async () => {
    const { procedure_info, procedure_params, statusCode } = await ReportQueries.getProcedureInfo('t');
    expect(statusCode).toBe(200);
    expect(Array.isArray(procedure_info)).toBe(false);
  });

  it('should create a new report', async () => {
    const procedure = {
      procedure_info: { procedure_id: procedura_id },
      procedure_params: params,
      new_report_name: 'test_report',
    };
    const { createdReport, statusCode } = await ReportQueries.createReport(procedure);

    expect(statusCode).toBe(200);
    expect(createdReport).toBeDefined();

    report_id = createdReport.report_info.report_id;
  });

  it('should get all reports', async () => {
    const { reports, statusCode } = await ReportQueries.getReports();
    expect(statusCode).toBe(200);
    expect(reports).toBeDefined();
    expect(Array.isArray(reports)).toBe(true);
  });

  it('should throw error when creating report with existing name', async () => {
    const procedure = {
      procedure_info: { procedure_id: procedura_id },
      procedure_params: params,
      new_report_name: 'test_report',
    };

    await expect(ReportQueries.createReport(procedure)).rejects.toThrow();
  });

  it('should throw error when creating report with invalid procedure', async () => {
    const procedure = {
      procedure_info: { procedure_id: 'invalid_id' },
      procedure_params: params,
      new_report_name: 'test_report_invalid_procedure',
    };

    await expect(ReportQueries.createReport(procedure)).rejects.toThrow();
  });

  it('should throw error when creating report with invalid data', async () => {
    const procedure = {
      procedure_info: { procedure_id: procedura_id },
      procedure_params: [],
      new_report_name: '',
    };

    await expect(ReportQueries.createReport(procedure)).rejects.toThrow();
  });

  it('should get report by id', async () => {
    const { report_info, report_params, statusCode } = await ReportQueries.getReportById(report_id);
    expect(statusCode).toBe(200);
    expect(report_info).toBeDefined();
    expect(report_params).toBeDefined();
  });

  it('should update report name only', async () => {
    const updatedReport = {
      report_info: {
        report_name: 'test_report_updated',
        procedure_id: procedura_id,
      },
      report_params: params,
    };

    const {
      updatedReport: { report_info, report_params },
      statusCode,
    } = await ReportQueries.updateReport(report_id, updatedReport);
    expect(statusCode).toBe(200);

    expect(report_info.report_name).toBe('test_report_updated');
  });

  it('should throw an error because report under that id doesnt exist ', async () => {
    const updatedReport = {
      report_info: {
        report_name: 'test_report_updated',
        procedure_id: procedura_id,
      },
      report_params: params,
    };

    await expect(ReportQueries.updateReport(99999, updatedReport)).rejects.toThrow();
  });

  it('should update report procedure only', async () => {
    const { procedure_info, procedure_params, statusCode } = await ReportQueries.getProcedureInfo('tst_procedure2');
    expect(statusCode).toBe(200);
    expect(procedure_info).toBeDefined();
    expect(procedure_params).toBeDefined();

    const updatedReport = {
      report_info: {
        report_name: 'test_report_updated2',
        procedure_id: procedure_info.procedure_id,
        report_id: report_id,
      },
      report_params: procedure_params,
    };

    const {
      updatedReport: { report_info, report_params },
      statusCode: status,
    } = await ReportQueries.updateReport(report_id, updatedReport);
    expect(status).toBe(200);

    procedura_id = procedure_info.procedure_id;

    expect(report_info.procedure_id).toBe(procedure_info.procedure_id);
  });

  it('should throw an error because procedure under that id doesnt exist ', async () => {
    const updatedReport = {
      report_info: {
        report_name: 'test_report_updated',
        procedure_id: '99999',
      },
      report_params: params,
    };

    await expect(ReportQueries.updateReport(report_id, updatedReport)).rejects.toThrow();
  });

  it('should execute the report', async () => {
    const params = require('../../sql/Queries/params');
    let { report_info, report_params } = await ReportQueries.getReportById(report_id);
    report_params = report_params.map((param) => ({ ...param }));

    input_params = {
      dateFrom: '2024.01.01',
      dateTo: '2024.01.31',
    };

    const queryParams = params.ReportParams(report_params, input_params);

    const { reportResult, statusCode } = await ReportQueries.executeReport(report_info.procedure_name, queryParams);

    expect(statusCode).toBe(200);
    expect(reportResult[0]).toEqual({
      datum_od: '2024.01.01',
      datum_do: '2024.01.31',
    });
  });

  it('should throw an error for the execution of the report because of invalid input params', async () => {
    const params = require('../../sql/Queries/params');
    let { report_info, report_params } = await ReportQueries.getReportById(report_id);
    report_params = report_params.map((param) => ({ ...param }));

    input_params = {
      date_From: '2024.01.01',
      date_To: '2024.01.31',
    };

    const queryParams = params.ReportParams(report_params, input_params);

    await expect(ReportQueries.executeReport('Not a real Procedure name', queryParams)).rejects.toThrow();
  });

  it('should throw an error for the execution of the report because of invalid procedure name', async () => {
    const params = require('../../sql/Queries/params');
    let { report_info, report_params } = await ReportQueries.getReportById(report_id);
    report_params = report_params.map((param) => ({ ...param }));

    input_params = {
      date_From: '2024.01.01',
      date_To: '2024.01.31',
    };

    const queryParams = params.ReportParams(report_params, input_params);

    await expect(ReportQueries.executeReport('Not a real Procedure name', queryParams)).rejects.toThrow();
  });

  it('should update report params only', async () => {
    params[0].sql_query = 'SELECT 1 as test';

    const updatedReport = {
      report_params: params,
      report_info: {
        report_name: 'tst_procedure2',
        procedure_id: procedura_id,
      },
    };

    const {
      updatedReport: { report_params },
      statusCode,
    } = await ReportQueries.updateReport(report_id, updatedReport);

    expect(statusCode).toBe(200);
    expect(report_params[0].sql_query).toBe('SELECT 1 as test');
  });

  it('should execute param sql query', async () => {
    const { report_info, report_params } = await ReportQueries.getReportById(report_id);

    const { param_values, statusCode } = await ReportQueries.getParamValues(report_info.procedure_id, report_id, report_params[0].param_name, 1);

    expect(statusCode).toBe(200);
    expect(param_values).toEqual({ test: 1 });
  });

  it('should update report params only', async () => {
    params[0].sql_query = '';

    const updatedReport = {
      report_params: params,
      report_info: {
        report_name: 'tst_procedure2',
        procedure_id: procedura_id,
      },
    };

    const {
      updatedReport: { report_params },
      statusCode,
    } = await ReportQueries.updateReport(report_id, updatedReport);

    expect(statusCode).toBe(200);
    expect(report_params[0].sql_query).toBe('');
  });

  it('should throw because param sql query is empty', async () => {
    const { report_info, report_params } = await ReportQueries.getReportById(report_id);

    await expect(ReportQueries.getParamValues(report_info.procedure_id, report_id, report_params[0].param_name, 1)).rejects.toThrow();
  });

  it('should delete the report', async () => {
    const { statusCode } = await ReportQueries.deleteReport(report_id);
    expect(statusCode).toBe(200);
  });

  it('should throw an error because report under that id doesnt exist ', async () => {
    await expect(ReportQueries.deleteReport(report_id)).rejects.toThrow();
  });

  it('should close the connection', async () => {
    const consoleSpy = jest.spyOn(console, 'log');
    await connection.close();
    expect(consoleSpy).toHaveBeenCalledWith('🔒 Connection to MSSQL database closed');
    consoleSpy.mockRestore();
  });
});
