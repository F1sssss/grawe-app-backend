const clientController = require('../../src/controllers/clientController');
const clientService = require('../../src/services/clientService');
const handleResponse = require('../../src/utils/responseHandler');

jest.mock('../../src/services/clientService');
jest.mock('../../src/utils/responseHandler');

describe('Client Controller', () => {
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

  describe('getClientHistory', () => {
    it('should call getClientHistoryService and handle response', async () => {
      const mockServiceResponse = { data: 'Client History' };
      clientService.getClientHistoryService.mockResolvedValue(mockServiceResponse);

      await clientController.getClientHistory(mockReq, mockRes, mockNext);

      expect(clientService.getClientHistoryService).toHaveBeenCalledWith('1', '2023-01-01', '2023-12-31');
      expect(handleResponse).toHaveBeenCalledWith(expect.any(Promise), mockRes);
    });
  });

  describe('getClientInfo', () => {
    it('should call getClientInfoService and handle response', async () => {
      const mockServiceResponse = { data: 'Client Info' };
      clientService.getClientInfoService.mockResolvedValue(mockServiceResponse);

      await clientController.getClientInfo(mockReq, mockRes, mockNext);

      expect(clientService.getClientInfoService).toHaveBeenCalledWith('1');
      expect(handleResponse).toHaveBeenCalledWith(expect.any(Promise), mockRes);
    });
  });

  describe('getClientAnalyticalInfo', () => {
    it('should call getClientAnalyticalInfoService and handle response', async () => {
      const mockServiceResponse = { data: 'Client Analytical Info' };
      clientService.getClientAnalyticalInfoService.mockResolvedValue(mockServiceResponse);

      await clientController.getClientAnalyticalInfo(mockReq, mockRes, mockNext);

      expect(clientService.getClientAnalyticalInfoService).toHaveBeenCalledWith('1', '2023-01-01', '2023-12-31');
      expect(handleResponse).toHaveBeenCalledWith(expect.any(Promise), mockRes);
    });
  });

  describe('getClientPolicyAnalyticalInfo', () => {
    it('should call getClientPolicyAnalyticalInfoService and handle response', async () => {
      const mockServiceResponse = { data: 'Client Policy Analytical Info' };
      clientService.getClientPolicyAnalyticalInfoService.mockResolvedValue(mockServiceResponse);

      await clientController.getClientPolicyAnalyticalInfo(mockReq, mockRes, mockNext);

      expect(clientService.getClientPolicyAnalyticalInfoService).toHaveBeenCalledWith('1', '2023-01-01', '2023-12-31');
      expect(handleResponse).toHaveBeenCalledWith(expect.any(Promise), mockRes);
    });
  });

  describe('getAllClientAnalytics', () => {
    it('should call getAllClientAnalyticsService and handle response', async () => {
      const mockServiceResponse = { data: 'All Client Analytics' };
      clientService.getAllClientAnalyticsService.mockResolvedValue(mockServiceResponse);

      await clientController.getAllClientAnalytics(mockReq, mockRes, mockNext);

      expect(clientService.getAllClientAnalyticsService).toHaveBeenCalledWith('1', '2023-01-01', '2023-12-31');
      expect(handleResponse).toHaveBeenCalledWith(expect.any(Promise), mockRes);
    });
  });

  describe('getAllClientInfo', () => {
    it('should call getAllClientInfoService and handle response', async () => {
      const mockServiceResponse = { data: 'All Client Info' };
      clientService.getAllClientInfoService.mockResolvedValue(mockServiceResponse);

      await clientController.getAllClientInfo(mockReq, mockRes, mockNext);

      expect(clientService.getAllClientInfoService).toHaveBeenCalledWith('1', '2023-01-01', '2023-12-31');
      expect(handleResponse).toHaveBeenCalledWith(expect.any(Promise), mockRes);
    });
  });

  describe('getClientHistoryExcelDownload', () => {
    it('should call getClientHistoryExcelDownloadService and send excel buffer', async () => {
      const mockExcelBuffer = Buffer.from('Mock Excel Data');
      clientService.getClientHistoryExcelDownloadService.mockResolvedValue({ excelBuffer: mockExcelBuffer });

      await clientController.getClientHistoryExcelDownload(mockReq, mockRes, mockNext);

      expect(clientService.getClientHistoryExcelDownloadService).toHaveBeenCalledWith(mockRes, '1', '2023-01-01', '2023-12-31');
      expect(mockRes.status).toHaveBeenCalledWith(200);
      expect(mockRes.send).toHaveBeenCalledWith(mockExcelBuffer);
    });
  });

  describe('getClientHistoryPDFDownload', () => {
    it('should call getPolicyHistoryPDFDownloadService and send pdf buffer', async () => {
      // Update mockReq to include ZK and AO query parameters
      mockReq = {
        params: { id: '1' },
        query: {
          dateFrom: '2023-01-01',
          dateTo: '2023-12-31',
          ZK: '1',
          AO: '1',
        },
      };

      const mockPDFBuffer = Buffer.from('Mock PDF Data');
      clientService.getPolicyHistoryPDFDownloadService.mockResolvedValue({ pdfBuffer: mockPDFBuffer });

      await clientController.getClientHistoryPDFDownload(mockReq, mockRes, mockNext);

      expect(clientService.getPolicyHistoryPDFDownloadService).toHaveBeenCalledWith(mockRes, '1', '2023-01-01', '2023-12-31', '1', '1');
      expect(mockRes.status).toHaveBeenCalledWith(200);
      expect(mockRes.send).toHaveBeenCalledWith(mockPDFBuffer);
    });
  });

  describe('getClientFinancialHistoryPDFDownload', () => {
    it('should call getClientFinancialHistoryPDFDownloadService and send pdf buffer', async () => {
      // Update mockReq to include ZK and AO query parameters
      mockReq = {
        params: { id: '1' },
        query: {
          dateFrom: '2023-01-01',
          dateTo: '2023-12-31',
          ZK: '1',
          AO: '1',
        },
      };

      const mockPDFBuffer = Buffer.from('Mock Financial PDF Data');
      clientService.getClientFinancialHistoryPDFDownloadService.mockResolvedValue({ pdfBuffer: mockPDFBuffer });

      await clientController.getClientFinancialHistoryPDFDownload(mockReq, mockRes, mockNext);

      expect(clientService.getClientFinancialHistoryPDFDownloadService).toHaveBeenCalledWith(mockRes, '1', '2023-01-01', '2023-12-31', '1', '1');
      expect(mockRes.status).toHaveBeenCalledWith(200);
      expect(mockRes.send).toHaveBeenCalledWith(mockPDFBuffer);
    });
  });
});
