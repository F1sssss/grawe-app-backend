const cacheQuery = require('../../utils/cacheQuery');
const ClientQueries = require('../../sql/Queries/clientQueries');
const generateExcelFile = require('../../utils/Exports/ExcelExport');
const Invoice = require('../../utils/Exports/createInvoice');
const FinancialInvoice = require('../../utils/Exports/createFinancialInvoice');
const AppError = require('../../utils/AppError');
const clientServices = require('../../services/clientService');
const clientQueries = require('../../sql/Queries/clientQueries');

jest.mock('../../utils/cacheQuery');
jest.mock('../../sql/Queries/clientQueries');
jest.mock('../../utils/Exports/ExcelExport');
jest.mock('../../utils/Exports/createInvoice');
jest.mock('../../utils/Exports/createFinancialInvoice');
jest.mock('../../utils/AppError');

describe('Client Services', () => {
  afterEach(() => {
    jest.clearAllMocks();
  });

  describe('getClientPolicyAnalyticalInfoService', () => {
    it('should call cacheQuery with correct parameters and return result', async () => {
      const id = '123';
      const dateFrom = '2023-01-01';
      const dateTo = '2023-12-31';
      const mockResult = { client: { id: '123', name: 'Test Client' }, statusCode: 200 };

      cacheQuery.mockResolvedValue(mockResult);

      const result = await clientServices.getClientPolicyAnalyticalInfoService(id, dateFrom, dateTo);

      expect(cacheQuery).toHaveBeenCalledWith(
        `client-policy-analytics-${id}-${dateFrom}-${dateTo}`,
        ClientQueries.getClientPolicyAnalticalInfo(id, dateFrom, dateTo),
      );
      expect(result).toEqual(mockResult);
    });
  });
  describe('getAllClientInfoService', () => {
    it('should call cacheQuery and return result with status code 200', async () => {
      const id = '456';
      const dateFrom = '2023-01-01';
      const dateTo = '2023-12-31';
      const mockClient = { id: '456', name: 'Test Client', policies: ['policy1', 'policy2'] };

      cacheQuery.mockResolvedValue({ client: mockClient });

      const result = await clientServices.getAllClientInfoService(id, dateFrom, dateTo);

      expect(cacheQuery).toHaveBeenCalledWith(
        `client-analytics-all-${id}-${dateFrom}-${dateTo}`,
        ClientQueries.getAllClientInfo(id, dateFrom, dateTo),
      );
      expect(result).toEqual({ client: mockClient, statusCode: 200 });
    });
  });

  describe('getClientHistoryService', () => {
    it('should retrieve client history and return client and status code', async () => {
      const mockResponse = { client: [{ id: 1, name: 'Client 1' }], statusCode: 200 };

      ClientQueries.getClientHistory.mockResolvedValue(Promise.resolve(mockResponse));
      cacheQuery.mockResolvedValue(mockResponse);

      const result = await clientServices.getClientHistoryService(1, '2023-01-01', '2023-12-31');

      expect(cacheQuery).toHaveBeenCalledWith('client-history-1-2023-01-01-2023-12-31', expect.any(Promise));
      expect(result).toEqual(mockResponse);
    });
  });

  describe('getClientInfoService', () => {
    it('should retrieve client info and return client and status code', async () => {
      const mockResponse = { client: { id: 1, name: 'Client 1' }, statusCode: 200 };

      ClientQueries.getClientInfo.mockResolvedValue(Promise.resolve(mockResponse));
      cacheQuery.mockResolvedValue(mockResponse);

      const result = await clientServices.getClientInfoService(1);

      expect(cacheQuery).toHaveBeenCalledWith('client-info-1', expect.any(Promise));
      expect(result).toEqual(mockResponse);
    });
  });

  describe('getClientAnalyticalInfoService', () => {
    it('should retrieve client analytical info and return client and status code', async () => {
      const mockResponse = { client: [{ id: 1, name: 'Client 1' }], statusCode: 200 };

      ClientQueries.getClientAnalyticalInfo.mockResolvedValue(Promise.resolve(mockResponse));
      cacheQuery.mockResolvedValue(mockResponse);

      const result = await clientServices.getClientAnalyticalInfoService(1, '2023-01-01', '2023-12-31');

      expect(cacheQuery).toHaveBeenCalledWith('client-analytical-info-1-2023-01-01-2023-12-31', expect.any(Promise));
      expect(result).toEqual(mockResponse);
    });
  });

  describe('getClientHistoryExcelDownloadService', () => {
    it('should generate and download client history as Excel', async () => {
      const mockClientHistory = [{ id: 1, name: 'Client 1' }];
      const mockExcelBuffer = Buffer.from('excel content');

      clientServices.getClientHistoryService = jest.fn().mockResolvedValue({ client: mockClientHistory });
      cacheQuery.mockResolvedValue({ client: mockClientHistory });
      generateExcelFile.mockResolvedValue({ excelBuffer: mockExcelBuffer, statusCode: 200 });

      const res = { setHeader: jest.fn() };

      const result = await clientServices.getClientHistoryExcelDownloadService(res, 1, '2023-01-01', '2023-12-31');

      expect(res.setHeader).toHaveBeenCalledWith('Content-Type', 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet');
      expect(generateExcelFile).toHaveBeenCalledWith(mockClientHistory);
      expect(result).toEqual({ excelBuffer: mockExcelBuffer, statusCode: 200 });
    });
  });

  describe('getPolicyHistoryPDFDownloadService', () => {
    it('should generate and download client policy history as PDF', async () => {
      const mockclient = [
        { id: 1, name: 'Client 1' },
        { id: 2, name: 'Client 2' },
      ];
      const mockPdfBuffer = Buffer.from('pdf content');

      ClientQueries.getAllClientInfo.mockResolvedValue(mockclient);
      cacheQuery.mockResolvedValue(mockclient);
      Invoice.createClientInvoice.mockResolvedValue({ pdfBuffer: mockPdfBuffer, statusCode: 200 });

      const res = { setHeader: jest.fn() };

      const result = await clientServices.getPolicyHistoryPDFDownloadService(res, 1, '2023-01-01', '2023-12-31');

      expect(res.setHeader).toHaveBeenCalledWith('Content-Type', 'application/pdf');
      expect(result).toEqual({ pdfBuffer: mockPdfBuffer, statusCode: 200 });
    });
  });
  describe('getAllClientAnalyticsService', () => {
    it('should return client history, analytical info, and download links', async () => {
      const mockClientHistory = { client: [{ id: 1, name: 'Client History' }], statusCode: 200 };
      const mockClientAnalyticalInfo = { client: [{ id: 1, name: 'Client Analytical Info' }], statusCode: 200 };

      clientServices.getClientHistoryService = jest.fn().mockResolvedValue(mockClientHistory);
      cacheQuery.mockResolvedValueOnce(mockClientHistory);
      clientServices.getClientAnalyticalInfoService = jest.fn().mockResolvedValue(mockClientAnalyticalInfo);
      cacheQuery.mockResolvedValueOnce(mockClientAnalyticalInfo);

      const result = await clientServices.getAllClientAnalyticsService(1, '2023-01-01', '2023-12-31');

      expect(result).toEqual({
        clientHistory: mockClientHistory,
        clientAnalyticalInfo: mockClientAnalyticalInfo,
        excelPath: expect.stringContaining('http://localhost:3000/api/v1/clients/1/history/xls/download'),
        pdfPath: expect.stringContaining('http://localhost:3000/api/v1/clients/1/history/pdf/download'),
      });
    });
  });

  describe('getClientFinancialHistoryPDFDownloadService', () => {
    it('should generate and download client financial history as PDF', async () => {
      const mockClient = { finHistory: [{ id: 1, name: 'Financial History' }] };
      const mockPdfBuffer = Buffer.from('pdf content');

      ClientQueries.getClientFinancialHistory.mockResolvedValue({ clientFinHistory: mockClient });
      ClientQueries.getClientFinancialInfo.mockResolvedValue({ clientFinInfo: {} });
      clientServices.getClientFinancialInfoService = jest.fn().mockResolvedValue({ client: mockClient });
      cacheQuery.mockResolvedValueOnce({ client: mockClient });
      FinancialInvoice.createClientInvoice.mockResolvedValue({ pdfBuffer: mockPdfBuffer, statusCode: 200 });
      cacheQuery.mockResolvedValueOnce({ pdfBuffer: mockPdfBuffer, statusCode: 200 });

      const res = { setHeader: jest.fn() };

      const result = await clientServices.getClientFinancialHistoryPDFDownloadService(res, 1, '2023-01-01', '2023-12-31');

      expect(res.setHeader).toHaveBeenCalledWith('Content-Type', 'application/pdf');
      expect(FinancialInvoice.createClientInvoice).toHaveBeenCalledWith(mockClient);
      expect(result).toEqual({ pdfBuffer: mockPdfBuffer, statusCode: 200 });
    });
  });
});
