const cacheQuery = require('../../utils/cacheQuery');
const PolicyQueries = require('../../sql/Queries/policiesQueries');
const generateExcelFile = require('../../utils/Exports/ExcelExport');
const Invoice = require('../../utils/Exports/createInvoice');
const policyServices = require('../../services/policyService');
const policyService = require('../../services/policyService');

// Mocking external dependencies
jest.mock('../../utils/cacheQuery');
jest.mock('../../sql/Queries/policiesQueries');
jest.mock('../../utils/Exports/ExcelExport');
jest.mock('../../utils/Exports/createInvoice');

describe('Policy Services', () => {
  afterEach(() => {
    jest.clearAllMocks(); // Clear mocks between tests
  });

  describe('getPolicyInfoService', () => {
    it('should retrieve policy info and return policy and status code', async () => {
      const mockResponse = { policy: { id: 1, name: 'Policy 1' }, statusCode: 200 };

      PolicyQueries.getPolicyInfo.mockResolvedValue(Promise.resolve(mockResponse));
      cacheQuery.mockResolvedValue(mockResponse);

      const result = await policyServices.getPolicyInfoService(1);

      expect(cacheQuery).toHaveBeenCalledWith('policy-info-1', expect.any(Promise));
      expect(result).toEqual(mockResponse);
    });
  });

  describe('getPolicyAnalyticalInfoService', () => {
    it('should retrieve policy analytical info and return policy and status code', async () => {
      const mockResponse = { policy: { id: 1, name: 'Policy 1' }, statusCode: 200 };

      PolicyQueries.getPolicyAnalyticalInfo.mockResolvedValue(Promise.resolve(mockResponse));
      cacheQuery.mockResolvedValue(mockResponse);

      const result = await policyServices.getPolicyAnalyticalInfoService(1, '2023-01-01', '2023-12-31');

      expect(cacheQuery).toHaveBeenCalledWith('policy-analytical-info-1-2023-01-01-2023-12-31', expect.any(Promise));
      expect(result).toEqual(mockResponse);
    });
  });

  describe('getPolicyHistoryService', () => {
    it('should retrieve policy history and return policy and status code', async () => {
      const mockResponse = { policy: { id: 1, name: 'Policy History' }, statusCode: 200 };

      PolicyQueries.getPolicyHistory.mockResolvedValue(Promise.resolve(mockResponse));
      cacheQuery.mockResolvedValue(mockResponse);

      const result = await policyServices.getPolicyHistoryService(1, '2023-01-01', '2023-12-31');

      expect(cacheQuery).toHaveBeenCalledWith('policy-history-1-2023-01-01-2023-12-31', expect.any(Promise));
      expect(result).toEqual(mockResponse);
    });
  });

  describe('getPolicyHistoryExcelDownloadService', () => {
    it('should generate and return excel file', async () => {
      const mockPolicy = [{ id: 1, date: '2023-01-01', action: 'Created' }];
      const mockRes = {
        setHeader: jest.fn(),
      };

      policyService.getPolicyHistoryService = jest.fn().mockResolvedValue({ policy: mockPolicy });
      generateExcelFile.mockResolvedValue({ excelBuffer: Buffer.from('mock excel data'), statusCode: 200 });

      const result = await policyService.getPolicyHistoryExcelDownloadService(mockRes, 1, '2023-01-01', '2023-12-31');

      expect(mockRes.setHeader).toHaveBeenCalledWith('Content-Type', 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet');
      expect(mockRes.setHeader).toHaveBeenCalledWith('Content-Disposition', 'attachment; filename="example.xlsx"');
      expect(result).toEqual({ excelBuffer: Buffer.from('mock excel data'), statusCode: 200 });
    });
  });

  describe('getPolicyHistoryPDFDownloadService', () => {
    it('should generate and return PDF file', async () => {
      const mockPolicy = { id: 1, details: 'Test Policy Details' };
      const mockRes = {
        setHeader: jest.fn(),
      };

      PolicyQueries.getPolicyExcelInfo = jest.fn().mockResolvedValue({ policy: mockPolicy });
      Invoice.createInvoice.mockResolvedValue({ pdfBuffer: Buffer.from('mock pdf data'), statusCode: 200 });

      const result = await policyService.getPolicyHistoryPDFDownloadService(mockRes, 1, '2023-01-01', '2023-12-31');

      expect(mockRes.setHeader).toHaveBeenCalledWith('Content-Type', 'application/pdf');
      expect(mockRes.setHeader).toHaveBeenCalledWith('Content-Disposition', 'attachment; filename="Invoice.pdf"');
      expect(result).toEqual({ pdfBuffer: Buffer.from('mock pdf data'), statusCode: 200 });
    });
  });
});
