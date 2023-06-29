const DBConnection = require('../DBConnection');
const PolicyQueries = require('../Queries/PoliciesQueries');

sql = {
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

describe('Policies queries tests', () => {
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

  it('should get info of a policy', async () => {
    const { policy } = await PolicyQueries.getPolicyInfo(91023194);
    expect(policy.Broj_Polise).toBe(91023194);
  });

  it('should get history of a policy', async () => {
    const { policy } = await PolicyQueries.getPolicyHistory(91023194, '2019.01.01', '2023.12.31');
    expect(policy.length).toBeGreaterThan(0);
  });

  it('should get analytical info of a policy', async () => {
    const { policy } = await PolicyQueries.getPolicyAnalyticalInfo(91023194, '2019.01.01', '2023.12.31');
    expect(policy.Broj_Polise).toBe(91023194);
  });

  it('should throw an error if policy does not exist', async () => {
    try {
      await PolicyQueries.getPolicyInfo(1);
    } catch (error) {
      expect(error.statusMessage).toBe('error-getting-policy-not-found');
    }
  });

  it('should not throw an error if policy does not exist', async () => {
    const { policy } = await PolicyQueries.getPolicyHistory(91023194, '2025.01.01', '2026.01.01');
    expect(policy).toBeDefined();
  });

  it('should not throw an error if policy does not exist', async () => {
    const { policy } = await PolicyQueries.getPolicyAnalyticalInfo(91023194, '2025.01.01', '2026.01.01');
    expect(policy).toBeDefined();
  });

  it('should close the connection', async () => {
    const consoleSpy = jest.spyOn(console, 'log');
    await connection.close();
    expect(consoleSpy).toHaveBeenCalledWith('🔒 Connection to MSSQL database closed');
    consoleSpy.mockRestore();
  });
});
