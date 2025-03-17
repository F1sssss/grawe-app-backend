const reportsService = require('./../../src/services/reportsService');
const reportsQueries = require('../../src/sql/Queries/reportsQueries');
const params = require('../../src/sql/Queries/params');
const cacheQuery = require('../../src/utils/cacheQuery');
const generateExcelFile = require('../../src/utils/Exports/ExcelExport');
const { delKey } = require('./../../src/services/cachingService');
const ReportQueue = require('../../src/utils/ReportQueue');

jest.mock('../../src/sql/Queries/reportsQueries');
jest.mock('../../src/sql/Queries/params');
jest.mock('../../src/utils/cacheQuery');
jest.mock('../../src/utils/Exports/ExcelExport');
jest.mock('./../../src/services/cachingService');
jest.mock('../../src/utils/ReportQueue');

describe('Report Services', () => {
  let mockReportQueue;

  beforeEach(() => {
    // Setup mock for ReportQueue
    mockReportQueue = {
      getOrQueueReport: jest.fn(),
    };

    // Update the mock to return our mock instance
    ReportQueue.mockImplementation(() => mockReportQueue);
  });

  afterEach(() => {
    jest.clearAllMocks();
  });

  describe('executeReport', () => {
    it('should execute a report and return the result', async () => {
      const mockReportInfo = { procedure_name: 'testProcedure' };
      const mockReportParams = [{ param_name: '@param1', type: 'VARCHAR' }];
      const mockInputParams = { param1: 'value1' };
      const mockQueryParams = [{ name: 'param1', value: 'value1', type: 'VARCHAR' }];
      const mockReportResult = { data: 'testData' };

      params.ReportParams.mockReturnValue(mockQueryParams);
      reportsQueries.executeReport.mockResolvedValue({ reportResult: mockReportResult, statusCode: 200 });
      cacheQuery.mockResolvedValue({ reportResult: mockReportResult, statusCode: 200 });

      const result = await reportsService.executeReport(mockReportInfo, mockReportParams, mockInputParams);

      expect(params.ReportParams).toHaveBeenCalledWith(mockReportParams, mockInputParams);
      expect(reportsQueries.executeReport).toHaveBeenCalledWith('testProcedure', mockQueryParams);
      expect(result).toEqual({ reportResult: mockReportResult, statusCode: 200 });
    });
  });

  describe('downloadFilteredReportService', () => {
    it('should download a filtered report', async () => {
      const mockRes = {
        setHeader: jest.fn(),
      };
      const mockReport = { data: 'filteredTestData' };
      const mockExcelBuffer = Buffer.from('mock filtered excel data');

      generateExcelFile.mockResolvedValue({ excelBuffer: mockExcelBuffer, statusCode: 200 });

      const result = await reportsService.downloadFilteredReportService(mockRes, mockReport);

      expect(mockRes.setHeader).toHaveBeenCalledTimes(2);
      expect(generateExcelFile).toHaveBeenCalledWith(mockReport);
      expect(result).toEqual({ excelBuffer: mockExcelBuffer, statusCode: 200 });
    });
  });

  describe('getReportService', () => {
    it('should get a report by id', async () => {
      const mockId = '123';
      const mockReportInfo = { procedure_name: 'testProcedure' };
      const mockReportParams = [{ param_name: '@param1', type: 'VARCHAR' }];

      reportsQueries.getReportById.mockResolvedValue({
        report_info: mockReportInfo,
        report_params: mockReportParams,
      });

      cacheQuery.mockResolvedValue({
        report_info: mockReportInfo,
        report_params: mockReportParams,
      });

      const result = await reportsService.getReportService(mockId);

      expect(result).toEqual({
        report_info: mockReportInfo,
        report_params: mockReportParams.map((param) => ({ ...param })),
      });
    });
  });

  describe('searchProcedureService', () => {
    it('should search for a procedure', async () => {
      const mockProcedureName = 'testProcedure';
      const mockProcedureInfo = { name: 'testProcedure', description: 'Test procedure' };
      const mockProcedureParams = [{ param_name: '@param1', type: 'VARCHAR' }];

      reportsQueries.getProcedureInfo.mockResolvedValue({
        procedure_info: mockProcedureInfo,
        procedure_params: mockProcedureParams,
        statusCode: 200,
      });

      const result = await reportsService.searchProcedureService(mockProcedureName);

      expect(reportsQueries.getProcedureInfo).toHaveBeenCalledWith(mockProcedureName);
      expect(result).toEqual({
        procedure_info: mockProcedureInfo,
        procedure_params: mockProcedureParams,
        statusCode: 200,
      });
    });
  });

  describe('createReportService', () => {
    it('should create a new report', async () => {
      const mockProcedure = { name: 'testProcedure', params: [{ param_name: '@param1', type: 'VARCHAR' }] };
      const mockCreatedReport = { id: '123', name: 'Test Report' };

      reportsQueries.createReport.mockResolvedValue({ createdReport: mockCreatedReport, statusCode: 201 });

      const result = await reportsService.createReportService(mockProcedure);

      expect(delKey).toHaveBeenCalledWith('get-reports');
      expect(delKey).toHaveBeenCalledWith('permissions');
      expect(delKey).toHaveBeenCalledWith('permission-groups');
      expect(reportsQueries.createReport).toHaveBeenCalledWith(mockProcedure);
      expect(result).toEqual({ createdReport: mockCreatedReport, statusCode: 201 });
    });
  });

  describe('updateReportService', () => {
    it('should update a report', async () => {
      const mockId = '123';
      const mockReport = { name: 'Updated Test Report' };
      const mockUpdatedReport = { id: '123', name: 'Updated Test Report' };

      reportsQueries.updateReport.mockResolvedValue({ updatedReport: mockUpdatedReport, statusCode: 200 });

      const result = await reportsService.updateReportService(mockId, mockReport);

      expect(delKey).toHaveBeenCalledWith(`get-report-${mockId}`);
      expect(reportsQueries.updateReport).toHaveBeenCalledWith(mockId, mockReport);
      expect(result).toEqual({ updatedReport: mockUpdatedReport, statusCode: 200 });
    });
  });

  describe('deleteReportService', () => {
    it('should delete a report', async () => {
      const mockId = '123';
      const mockDeletedReport = { id: '123', name: 'Deleted Test Report' };

      reportsQueries.deleteReport.mockResolvedValue({ deletedReport: mockDeletedReport, statusCode: 200 });

      const result = await reportsService.deleteReportService(mockId);

      expect(delKey).toHaveBeenCalledWith(`get-report-${mockId}`);
      expect(reportsQueries.deleteReport).toHaveBeenCalledWith(mockId);
      expect(result).toEqual({ deletedReport: mockDeletedReport, statusCode: 200 });
    });
  });
});
