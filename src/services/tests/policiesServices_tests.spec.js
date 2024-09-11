const { getPolicyInfo, getPolicyAnalyticalInfo, getPolicyHistory } = require('../../sql/Queries/PoliciesQueries');
let { getPolicyInfoService, getPolicyAnalyticalInfoService, getPolicyHistoryService } = require('../policyService');
const cacheQuery = require('../../utils/cacheQuery');

jest.mock('../../sql/Queries/PoliciesQueries');
jest.mock('../../utils/cacheQuery');
describe('policies servicecs tests', () => {
  it('should get policy info', async () => {
    getPolicyInfo.mockReturnValue({ policy: 'policy' });
    cacheQuery.mockReturnValue({ data: { policy: 'policy' } });
    const {
      data: { policy },
    } = await getPolicyInfoService(1);
    expect(policy).toBe('policy');
  });

  it('should get policy analytical info ', async () => {
    getPolicyAnalyticalInfo.mockReturnValue({ policy: 'policy' });
    cacheQuery.mockReturnValue({ data: { policy: 'policy' } });
    const {
      data: { policy },
    } = await getPolicyAnalyticalInfoService(1, '2020.01.01', '2021.01.01');
    expect(policy).toBe('policy');
  });

  it('should get policy history', async () => {
    getPolicyHistory.mockReturnValue({ policy: 'policy' });
    cacheQuery.mockReturnValue({ data: { policy: 'policy' } });
    const {
      data: { policy },
    } = await getPolicyHistoryService(1, '2020.01.01', '2021.01.01');
    expect(policy).toBe('policy');
  });
});
