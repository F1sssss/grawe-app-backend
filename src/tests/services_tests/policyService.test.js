const policyService = require('../../services/policyService');
const PolicyQueries = require('../../sql/Queries/PoliciesQueries');
const cacheQuery = require('../../utils/cacheQuery');

jest.mock('../../sql/Queries/PoliciesQueries');
jest.mock('../../utils/cacheQuery');

describe('Policy Service', () => {
  it('should return policy info from service', async () => {
    const mockPolicyData = { policy: { id: '123', name: 'Test Policy' }, statusCode: 200 };
    cacheQuery.mockResolvedValue(mockPolicyData);

    const result = await policyService.getPolicyInfoService('123');

    expect(result).toEqual(mockPolicyData);
    expect(cacheQuery).toHaveBeenCalledWith('policy-info-123', PolicyQueries.getPolicyInfo('123'));
  });

  it('should return policy analytical info from service', async () => {
    const mockPolicyData = { policy: { id: '123', analytics: 'Analytical Data' }, statusCode: 200 };
    cacheQuery.mockResolvedValue(mockPolicyData);

    const result = await policyService.getPolicyAnalyticalInfoService('123', '2023-01-01', '2023-01-31');

    expect(result).toEqual(mockPolicyData);
    expect(cacheQuery).toHaveBeenCalledWith(
      'policy-analytical-info-123-2023-01-01-2023-01-31',
      PolicyQueries.getPolicyAnalyticalInfo('123', '2023-01-01', '2023-01-31'),
    );
  });

  it('should return policy history from service', async () => {
    const mockPolicyData = { policy: { id: '123', history: 'Policy History' }, statusCode: 200 };
    cacheQuery.mockResolvedValue(mockPolicyData);

    const result = await policyService.getPolicyHistoryService('123', '2023-01-01', '2023-01-31');

    expect(result).toEqual(mockPolicyData);
    expect(cacheQuery).toHaveBeenCalledWith(
      'policy-history-123-2023-01-01-2023-01-31',
      PolicyQueries.getPolicyHistory('123', '2023-01-01', '2023-01-31'),
    );
  });

  it('should return all policy analytics from service', async () => {
    const mockPolicyHistory = { policy: { id: '123', history: 'Policy History' }, statusCode: 200 };
    const mockPolicyAnalyticalInfo = { policy: { id: '123', analytics: 'Analytical Data' }, statusCode: 200 };

    mock_policyHistory = jest.fn().mockResolvedValue(mockPolicyHistory);
    mock_policyAnalyticalInfo = jest.fn().mockResolvedValue(mockPolicyAnalyticalInfo);

    const result = await policyService.getAllPolicyAnalyticsService('123', '2023-01-01', '2023-01-31');

    expect(result.policyHistory).toEqual(mockPolicyHistory);
    expect(result.policyAnalyticalInfo).toEqual(mockPolicyAnalyticalInfo);
  });

  it('should return excel buffer for policy history', async () => {
    const mockExcelBuffer = Buffer.from('Excel file content');
    policyService.getPolicyHistoryService.mockResolvedValue({ policy: 'Policy Data' });
    const generateExcelFile = jest.fn().mockResolvedValue({ excelBuffer: mockExcelBuffer, statusCode: 200 });

    const result = await policyService.getPolicyHistoryExcelDownloadService({}, '123', '2023-01-01', '2023-01-31');

    expect(result.excelBuffer).toEqual(mockExcelBuffer);
  });

  it('should return pdf buffer for policy history', async () => {
    const mockPdfBuffer = Buffer.from('PDF file content');
    PolicyQueries.getPolicyExcelInfo.mockResolvedValue({ policy: 'Policy Data' });
    const createInvoice = jest.fn().mockResolvedValue({ pdfBuffer: mockPdfBuffer, statusCode: 200 });

    const result = await policyService.getPolicyHistoryPDFDownloadService({}, '123', '2023-01-01', '2023-01-31');

    expect(result.pdfBuffer).toEqual(mockPdfBuffer);
  });
});
