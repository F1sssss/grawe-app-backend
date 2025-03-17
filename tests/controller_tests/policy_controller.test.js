const policyController = require('../../src/controllers/policyController');
const policyService = require('../../src/services/policyService');
const handleResponse = require('../../src/utils/responseHandler');

jest.mock('../../src/services/policyService');
jest.mock('../../src/utils/responseHandler');

describe('Policy Controller', () => {
  let mockReq, mockRes, mockNext;

  beforeEach(() => {
    mockReq = {
      params: { id: '1' },
      query: { dateFrom: '2023-01-01', dateTo: '2023-12-31' },
    };
    mockRes = {
      status: jest.fn().mockReturnThis(),
      send: jest.fn(),
    };
    mockNext = jest.fn();
  });

  afterEach(() => {
    jest.clearAllMocks();
  });

  describe('getPolicyInfo', () => {
    it('should call getPolicyInfoService and handle response', async () => {
      const mockServiceResponse = { data: 'Policy Info' };
      policyService.getPolicyInfoService.mockResolvedValue(mockServiceResponse);

      await policyController.getPolicyInfo(mockReq, mockRes, mockNext);

      expect(policyService.getPolicyInfoService).toHaveBeenCalledWith('1');
      expect(handleResponse).toHaveBeenCalledWith(expect.any(Promise), mockRes, { statusCode: 200 });
    });
  });

  describe('getPolicyAnalyticalInfo', () => {
    it('should call getPolicyAnalyticalInfoService and handle response', async () => {
      const mockServiceResponse = { data: 'Policy Analytical Info' };
      policyService.getPolicyAnalyticalInfoService.mockResolvedValue(mockServiceResponse);

      await policyController.getPolicyAnalyticalInfo(mockReq, mockRes, mockNext);

      expect(policyService.getPolicyAnalyticalInfoService).toHaveBeenCalledWith('1', '2023-01-01', '2023-12-31');
      expect(handleResponse).toHaveBeenCalledWith(expect.any(Promise), mockRes, { statusCode: 200 });
    });
  });

  describe('getPolicyHistory', () => {
    it('should call getPolicyHistoryService and handle response', async () => {
      const mockServiceResponse = { data: 'Policy History' };
      policyService.getPolicyHistoryService.mockResolvedValue(mockServiceResponse);

      await policyController.getPolicyHistory(mockReq, mockRes, mockNext);

      expect(policyService.getPolicyHistoryService).toHaveBeenCalledWith('1', '2023-01-01', '2023-12-31');
      expect(handleResponse).toHaveBeenCalledWith(expect.any(Promise), mockRes, { statusCode: 200 });
    });
  });

  describe('getAllPolicyAnalytics', () => {
    it('should call getAllPolicyAnalyticsService and handle response', async () => {
      const mockServiceResponse = { data: 'All Policy Analytics' };
      policyService.getAllPolicyAnalyticsService.mockResolvedValue(mockServiceResponse);

      await policyController.getAllPolicyAnalytics(mockReq, mockRes, mockNext);

      expect(policyService.getAllPolicyAnalyticsService).toHaveBeenCalledWith('1', '2023-01-01', '2023-12-31');
      expect(handleResponse).toHaveBeenCalledWith(expect.any(Promise), mockRes, { statusCode: 200 });
    });
  });

  describe('getPolicyHistoryExcelDownload', () => {
    it('should call getPolicyHistoryExcelDownloadService and send excel buffer', async () => {
      const mockExcelBuffer = Buffer.from('Mock Excel Data');
      policyService.getPolicyHistoryExcelDownloadService.mockResolvedValue({ excelBuffer: mockExcelBuffer });

      await policyController.getPolicyHistoryExcelDownload(mockReq, mockRes, mockNext);

      expect(policyService.getPolicyHistoryExcelDownloadService).toHaveBeenCalledWith(mockRes, '1', '2023-01-01', '2023-12-31');
      expect(mockRes.send).toHaveBeenCalledWith(mockExcelBuffer);
    });
  });

  describe('getPolicyHistoryPDFDownload', () => {
    it('should call getPolicyHistoryPDFDownloadService and send pdf buffer', async () => {
      const mockPDFBuffer = Buffer.from('Mock PDF Data');
      policyService.getPolicyHistoryPDFDownloadService.mockResolvedValue({ pdfBuffer: mockPDFBuffer, statusCode: 200 });

      await policyController.getPolicyHistoryPDFDownload(mockReq, mockRes, mockNext);

      expect(policyService.getPolicyHistoryPDFDownloadService).toHaveBeenCalledWith(mockRes, '1', '2023-01-01', '2023-12-31');
      expect(mockRes.status).toHaveBeenCalledWith(200);
      expect(mockRes.send).toHaveBeenCalledWith(mockPDFBuffer);
    });
  });
});
