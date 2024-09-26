const DBConnection = require('../../sql/DBConnection');
const ClientQueries = require('../../sql/Queries/employeeErrorQueries');
const DB_CONFIG = require('../../sql/DBconfig');
const sql = require('../../tests/sql_test');
const { getPolicyInfo } = require('../../sql/Queries/policiesQueries');
const { getMeService } = require('../../services/userService');

jest.mock('../../sql/Queries/policiesQueries');
jest.mock('../../services/userService');

describe('Employee errors queries', () => {
  beforeAll(() => {
    connection = new DBConnection(sql);
    jest.setTimeout(500000);
  });

  it('should connect to the test database', async () => {
    const consoleSpy = jest.spyOn(console, 'log');
    await connection.connect();
    expect(consoleSpy).toHaveBeenCalledWith('🔒 Connected to MSSQL database');
    consoleSpy.mockRestore();
  });

  it('should add a record for an employee error for testing', async () => {
    const connection = new DBConnection(DB_CONFIG.sql);
    const result = await connection.executeQuery(
      "insert into gr_dnevne_greske (id_greske,polisa,opis_greske,datum_greske) values (1,'9900034','Test error','2000.01.01') select * from gr_dnevne_greske where polisa = 9900034",
    );
    expect(result).toBeDefined();
  });

  it('should get all employee errors', async () => {
    const result = await ClientQueries.getEmployeeErrors('2000.01.01');
    const expected_errors = [
      {
        id_greske: 1,
        polisa: 9900034,
        opis_greske: 'Test error',
      },
    ];
    expect(result.statusCode).toBe(200);

    const { employee_errors } = result;
    expect(employee_errors[0]).toMatchObject({
      id_greske: expected_errors[0].id_greske,
      polisa: expected_errors[0].polisa,
      opis_greske: expected_errors[0].opis_greske,
    });
  });

  it('should return an empty array if there are no employee errors', async () => {
    const result = await ClientQueries.getEmployeeErrors('2000.01.02');
    expect(result.statusCode).toBe(200);
    expect(result.employee_errors).toEqual([]);
  });

  it('should get all exceptions', async () => {
    const result = await ClientQueries.getErrorExceptions();
    expect(result.statusCode).toBe(200);

    const { exceptions } = result;
    expect(exceptions).toBeDefined();
  });

  it('should return an empty array if there are no exceptions', async () => {
    const result = await ClientQueries.getErrorExceptions();
    expect(result.statusCode).toBe(200);
    expect(result.exceptions).toEqual([]);
  });

  it('should add an error exception', async () => {
    getPolicyInfo.mockResolvedValueOnce({ policy: 1 });
    getMeService.mockResolvedValueOnce({ user: { ID: 1 } });

    const expected_result = {
      polisa: 9900034,
      id_greske: 1,
      komentar: 'Test exception',
      user_exception: 1,
    };

    const result = await ClientQueries.addErrorException('9900034', 1, 'Test exception', {});

    expect(result.statusCode).toBe(200);

    expect(result.result).toMatchObject({
      polisa: expected_result.polisa,
      id_greske: expected_result.id_greske,
      komentar: expected_result.komentar,
      user_exception: expected_result.user_exception,
    });
  });

  it('should not add an error exception if the policy does not exist', async () => {
    getPolicyInfo.mockResolvedValueOnce({ policy: {} });
    await expect(ClientQueries.addErrorException('9900034', 1, 'Test exception', {})).rejects.toThrow();
  });

  it('should delete an error exception', async () => {
    const result = await ClientQueries.deleteErrorException('9900034', 1);
    expect(result.statusCode).toBe(200);
    expect(result.result).toBe('Successfully deleted exception!');
  });

  it('should remove a record for an employee error for testing', async () => {
    const connection = new DBConnection(DB_CONFIG.sql);
    const result = await connection.executeQuery('delete from gr_dnevne_greske where polisa = 98006394');
    expect(result).toBeUndefined();
  });

  it('should close the connection', async () => {
    const consoleSpy = jest.spyOn(console, 'log');
    await connection.close();
    expect(consoleSpy).toHaveBeenCalledWith('🔒 Connection to MSSQL database closed');
    consoleSpy.mockRestore();
  });
});
