const DBConnection = require('../../sql/DBConnection');
const PolicyQueries = require('../../sql/Queries/policiesQueries');
const { correct_policies_values } = require('../testing_values/correct_values');
const sql = require('../../tests/sql_test');

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
    const { policy } = await PolicyQueries.getPolicyInfo(correct_policies_values[0].Broj_Polise);
    expect(policy.Broj_Polise).toBe(correct_policies_values[0].Broj_Polise);
  });

  it('should get excel info of a policy', async () => {
    const { policy } = await PolicyQueries.getPolicyExcelInfo(correct_policies_values[0].Broj_Polise, '2024.01.01', '2024.07.31');
    expect(policy).toBeDefined();
  });

  it('should return empty object if policy does not exist', async () => {
    const { policy } = await PolicyQueries.getPolicyExcelInfo(9999999, '2024.01.01', '2024.07.31');
    expect(policy).toEqual({});
  });

  it('should return an empty object if policy does not exist', async () => {
    const { policy } = await PolicyQueries.getPolicyInfo(9999999);
    expect(policy).toEqual({});
  });

  it('should get history of a policy', async () => {
    const { policy } = await PolicyQueries.getPolicyHistory(correct_policies_values[0].Broj_Polise, '2024.01.01', '2024.07.31');
    expect(policy.length).toBeGreaterThan(0);
  });

  it('should get history of a policy', async () => {
    const { policy } = await PolicyQueries.getPolicyHistory(1001573, '2024.01.01', '2024.07.31');
    expect(Array.isArray(policy)).toBe(true);
  });

  it('should return an empty object if policy does not exist', async () => {
    const { policy } = await PolicyQueries.getPolicyAnalyticalInfo(9999999);
    expect(policy).toEqual({});
  });

  it('should get analytical info of all policies with a correct result', async () => {
    for (let i = 0; i < correct_policies_values.length; i++) {
      let { policy } = await PolicyQueries.getPolicyAnalyticalInfo(correct_policies_values[i].Broj_Polise, '2024.01.01', '2024.07.31');
      const policy_filter = {
        Broj_Polise: correct_policies_values[i].Broj_Polise,
        Pol_kreis: correct_policies_values[i].Pol_kreis,
        Bruto_polisirana_premija: correct_policies_values[i].Bruto_polisirana_premija,
        Neto_polisirana_premija: correct_policies_values[i].Neto_polisirana_premija,
        Premija: correct_policies_values[i].Premija,
        Status_Polise: correct_policies_values[i].Status_Polise,
      };

      if (Array.isArray(policy)) {
        policy = policy[0];
      }

      expect(policy).toMatchObject({
        Broj_Polise: policy_filter.Broj_Polise,
        Pol_kreis: policy_filter.Pol_kreis,
        Bruto_polisirana_premija: policy_filter.Bruto_polisirana_premija,
        Neto_polisirana_premija: policy_filter.Neto_polisirana_premija,
        Premija: policy_filter.Premija,
        Status_Polise: policy_filter.Status_Polise,
        //Naziv_zastupnika: correct_policies_values[i].Naziv_zastupnika,
        //Ugovarac: correct_policies_values[i].Ugovarac,
      });
    }
  }, 100000);

  it('should not throw an error if policy does not exist', async () => {
    const { policy } = await PolicyQueries.getPolicyHistory(9999999, '2025.01.01', '2026.01.01');
    expect(policy).toBeDefined();
  });

  it('should close the connection', async () => {
    const consoleSpy = jest.spyOn(console, 'log');
    await connection.close();
    expect(consoleSpy).toHaveBeenCalledWith('🔒 Connection to MSSQL database closed');
    consoleSpy.mockRestore();
  });
});
