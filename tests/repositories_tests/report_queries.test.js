const DBConnection = require('../../src/sql/DBConnection');
const ReportQueries = require('../../src/sql/Queries/reportsQueries');
const sql = require('../sql_test');

describe('Report queries tests', () => {
  let connection;
  let procedura_id;
  let params;
  let report_id;
  const testProcedureName = 'test_procedure_' + Date.now(); // Use timestamp to ensure uniqueness

  beforeAll(() => {
    connection = new DBConnection(sql);
    jest.setTimeout(50000000);
  });

  it('should connect to the test database', async () => {
    const originalConnect = connection.connect;
    connection.connect = jest.fn().mockImplementation(async () => {
      await originalConnect.call(connection);
    });

    await connection.connect();
    expect(connection.connect).toHaveBeenCalled();

    connection.connect = originalConnect;
  }, 50000);

  it('should create a test stored procedure', async () => {
    // Create a simple stored procedure for testing
    const createProcedureQuery = `
    CREATE PROCEDURE ${testProcedureName}
      @dateFrom VARCHAR(100),
      @dateTo VARCHAR(100)
    AS
    BEGIN
      SELECT @dateFrom AS datum_od, @dateTo AS datum_do;
    END
    `;

    try {
      await connection.executeQuery(createProcedureQuery);
      // Wait a little for the procedure to be available in the system tables
      await new Promise((resolve) => setTimeout(resolve, 1000));
    } catch (error) {
      console.error('Failed to create test procedure:', error);
      throw error;
    }
  });

  it('should find the newly created procedure info', async () => {
    const { procedure_info, procedure_params, statusCode } = await ReportQueries.getProcedureInfo(testProcedureName);
    expect(statusCode).toBe(200);
    expect(procedure_info).toBeDefined();
    expect(procedure_params).toBeDefined();
    expect(procedure_info.procedure_name).toBe(testProcedureName);

    procedura_id = procedure_info.procedure_id;
    params = procedure_params;
  });

  it('should return empty object when finding procedure info', async () => {
    const { procedure_info, procedure_params, statusCode } = await ReportQueries.getProcedureInfo('blabla');
    expect(statusCode).toBe(200);
    expect(procedure_info).toStrictEqual({});
    expect(procedure_params).toStrictEqual([]);
  });

  it('should create a new report', async () => {
    const procedure = {
      procedure_info: { procedure_id: procedura_id },
      procedure_params: params,
      new_report_name: 'test_report_' + Date.now(), // Use timestamp to ensure uniqueness
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
    // Get the current report's name
    const { report_info } = await ReportQueries.getReportById(report_id);

    const procedure = {
      procedure_info: { procedure_id: procedura_id },
      procedure_params: params,
      new_report_name: report_info.report_name, // Use the same name to trigger error
    };

    await expect(ReportQueries.createReport(procedure)).rejects.toThrow();
  });

  it('should throw error when creating report with invalid procedure', async () => {
    const procedure = {
      procedure_info: { procedure_id: 999999 }, // Invalid procedure ID
      procedure_params: params,
      new_report_name: 'test_report_invalid_procedure',
    };

    await expect(ReportQueries.createReport(procedure)).rejects.toThrow();
  });

  it('should throw error when creating report with invalid data', async () => {
    const procedure = {
      procedure_info: { procedure_id: procedura_id },
      procedure_params: [],
      new_report_name: '', // Invalid empty name
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
    const newName = 'test_report_updated_' + Date.now(); // Use timestamp to ensure uniqueness
    const updatedReport = {
      report_info: {
        report_name: newName,
        procedure_id: procedura_id,
      },
      report_params: params,
    };

    const {
      updatedReport: { report_info, report_params },
      statusCode,
    } = await ReportQueries.updateReport(report_id, updatedReport);
    expect(statusCode).toBe(200);

    expect(report_info.report_name).toBe(newName);
  });

  it('should throw an error because report under that id doesnt exist', async () => {
    const updatedReport = {
      report_info: {
        report_name: 'test_report_updated',
        procedure_id: procedura_id,
      },
      report_params: params,
    };

    await expect(ReportQueries.updateReport(99999, updatedReport)).rejects.toThrow();
  });

  it('should execute the report', async () => {
    const params = require('../../src/sql/Queries/params');
    let { report_info, report_params } = await ReportQueries.getReportById(report_id);
    report_params = report_params.map((param) => ({ ...param }));

    const input_params = {
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

  it('should throw an error for the execution of the report with wrong parameter names', async () => {
    const paramsModule = require('../../src/sql/Queries/params');
    let { report_info, report_params } = await ReportQueries.getReportById(report_id);
    report_params = report_params.map((param) => ({ ...param }));

    const numParams = report_params.length;
    const input_params =
      numParams === 2
        ? { wrongParam1: '2024.01.01' } // 1 param for a 2-param procedure
        : { wrongParam1: '2024.01.01', wrongParam2: '2024.01.31', wrongParam3: 'extra' }; // 3 params

    expect(() => {
      paramsModule.ReportParams(report_params, input_params);
    }).toThrow('Error during retrieving reports');
  });

  it('should throw an error for the execution of the report because of invalid procedure name', async () => {
    const params = require('../../src/sql/Queries/params');
    let { report_info, report_params } = await ReportQueries.getReportById(report_id);
    report_params = report_params.map((param) => ({ ...param }));

    const input_params = {
      dateFrom: '2024.01.01',
      dateTo: '2024.01.31',
    };

    const queryParams = params.ReportParams(report_params, input_params);

    await expect(ReportQueries.executeReport('Not_A_Real_Procedure_Name', queryParams)).rejects.toThrow();
  });

  it('should update report params only', async () => {
    let { report_info, report_params } = await ReportQueries.getReportById(report_id);

    expect(report_params.length).toBeGreaterThan(0);

    const updatedParams = JSON.parse(JSON.stringify(report_params));

    updatedParams.forEach((param) => {
      param.sql_query = 'SELECT 1 as test';
    });

    const updatedReport = {
      report_info: {
        report_id: report_id,
        report_name: report_info.report_name,
        procedure_id: report_info.procedure_id,
      },
      report_params: updatedParams,
    };

    const result = await ReportQueries.updateReport(report_id, updatedReport);
    expect(result.statusCode).toBe(200);

    const { report_params: verifyParams } = await ReportQueries.getReportById(report_id);

    const sqlQueryUpdated = verifyParams.some((param) => param.sql_query === 'SELECT 1 as test');
    expect(sqlQueryUpdated).toBe(true);
  });

  it('should execute param sql query', async () => {
    const { report_info, report_params } = await ReportQueries.getReportById(report_id);

    // Find the parameter's order
    const paramOrder = report_params[0].order || 1;

    const { param_values, statusCode } = await ReportQueries.getParamValues(
      report_info.procedure_id,
      report_id,
      report_params[0].param_name,
      paramOrder,
    );

    expect(statusCode).toBe(200);
    expect(param_values).toHaveProperty('test');
  });

  it('should update report params to empty sql query', async () => {
    // First get the current parameters
    const { report_info, report_params } = await ReportQueries.getReportById(report_id);

    // Clone the parameters and set SQL query to empty
    const updatedParams = report_params.map((param) => ({
      ...param,
      sql_query: '',
    }));

    const updatedReport = {
      report_info: report_info,
      report_params: updatedParams,
    };

    const {
      updatedReport: { report_params: resultParams },
      statusCode,
    } = await ReportQueries.updateReport(report_id, updatedReport);

    expect(statusCode).toBe(200);
    expect(resultParams[0].sql_query).toBe('');
  });

  it('should throw because param sql query is empty', async () => {
    const { report_info, report_params } = await ReportQueries.getReportById(report_id);

    // Find the parameter's order
    const paramOrder = report_params[0].order || 1;

    await expect(ReportQueries.getParamValues(report_info.procedure_id, report_id, report_params[0].param_name, paramOrder)).rejects.toThrow();
  });

  it('should delete the report', async () => {
    const { statusCode } = await ReportQueries.deleteReport(report_id);
    expect(statusCode).toBe(200);
  });

  it('should throw an error because report under that id doesnt exist', async () => {
    await expect(ReportQueries.deleteReport(report_id)).rejects.toThrow();
  });

  it('should drop the test stored procedure', async () => {
    // Drop the stored procedure we created
    const dropProcedureQuery = `
    IF OBJECT_ID('${testProcedureName}', 'P') IS NOT NULL
      DROP PROCEDURE ${testProcedureName};
    `;

    try {
      await connection.executeQuery(dropProcedureQuery);
    } catch (error) {
      console.error('Failed to drop test procedure:', error);
      throw error;
    }
  });

  it('should close the connection', async () => {
    const originalClose = connection.close;
    connection.close = jest.fn().mockImplementation(async () => {
      await originalClose.call(connection);
    });

    await connection.close();
    expect(connection.close).toHaveBeenCalled();

    connection.close = originalClose;
  });
});
