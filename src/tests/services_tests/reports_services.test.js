const {
  generateReportService,
  createReportService,
  getReportService,
  searchProcedureService,
  updateReportService,
  deleteReportService,
  executeReport,
  downloadReportService,
  downloadFilteredReportService,
} = require('./../../services/reportsService');

const reportsQueries = require('../../sql/Queries/reportsQueries');
const params = require('../../sql/Queries/params');
const cacheQuery = require('../../utils/cacheQuery');
const generateExcelFile = require('../../utils/Exports/ExcelExport');
const { delKey } = require('./../../services/cachingService');

jest.mock('../../sql/Queries/reportsQueries');
jest.mock('../../sql/Queries/params');
jest.mock('../../utils/cacheQuery');
jest.mock('../../utils/Exports/ExcelExport');
jest.mock('./../../services/cachingService');

jest.mock('./../../services/reportsService', () => {
  const originalModule = jest.requireActual('./../../services/reportsService');
  return {
    ...originalModule,
    getReportService: jest.fn(),
    executeReport: jest.fn(),
  };
});
describe('Report Services', () => {
  afterEach(() => {
    jest.clearAllMocks();
  });
  describe('executeReport', () => {
    it('should execute a report and return the result', async () => {
      const mockReportInfo = { procedure_name: 'testProcedure' };
      const mockReportParams = [{ param1: 'value1' }];
      const mockInputParams = { input1: 'value1' };
      const mockQueryParams = { param1: 'value1', input1: 'value1' };
      const mockReportResult = { data: 'testData' };

      reportsQueries.executeReport.mockResolvedValue({ reportResult: mockReportResult, statusCode: 200 });
      cacheQuery.mockResolvedValueOnce({ reportResult: mockReportResult, statusCode: 200 });
      cacheQuery.mockResolvedValueOnce({ reportResult: mockReportResult, statusCode: 200 });
      cacheQuery.mockResolvedValueOnce({ reportResult: mockReportResult, statusCode: 200 });

      const result = await executeReport(mockReportInfo, mockReportParams, mockInputParams);
      expect(result).toEqual({ reportResult: mockReportResult, statusCode: 200 });
    });
  });

  describe('generateReportService', () => {
    afterEach(() => {
      jest.clearAllMocks();
    });

    it('should generate a report', async () => {
      const mockId = '123';
      const mockInputParams = { input1: 'value1' };
      const mockReportInfo = { procedure_name: 'testProcedure' };
      const mockReportParams = [{ param1: 'value1' }];
      const mockReportResult = { data: 'testData' };

      getReportService.mockResolvedValue({ report_info: mockReportInfo, report_params: mockReportParams });
      cacheQuery.mockResolvedValueOnce({ report_info: mockReportInfo, report_params: mockReportParams });
      executeReport.mockResolvedValue({ reportResult: mockReportResult, statusCode: 200 });
      cacheQuery.mockResolvedValue({ reportResult: mockReportResult, statusCode: 200 });

      const result = await generateReportService(mockId, mockInputParams);

      expect(result).toEqual({ reportResult: mockReportResult, statusCode: 200 });
    });
  });

  describe('downloadReportService', () => {
    afterEach(() => {
      jest.clearAllMocks();
    });

    it('should download a report', async () => {
      const mockRes = {
        setHeader: jest.fn(),
      };
      const mockId = '123';
      const mockInputParams = { input1: 'value1' };
      const mockReportInfo = { procedure_name: 'testProcedure' };
      const mockReportParams = [{ param1: 'value1' }];
      const mockReportResult = { data: 'testData' };
      const mockExcelBuffer = Buffer.from('mock excel data');

      getReportService.mockResolvedValue({ report_info: mockReportInfo, report_params: mockReportParams });
      cacheQuery.mockResolvedValueOnce({ report_info: mockReportInfo, report_params: mockReportParams });
      executeReport.mockResolvedValue({ reportResult: mockReportResult });
      cacheQuery.mockResolvedValueOnce({ reportResult: mockReportResult });
      generateExcelFile.mockResolvedValue({ excelBuffer: mockExcelBuffer, statusCode: 200 });

      const result = await downloadReportService(mockRes, mockId, mockInputParams);

      expect(mockRes.setHeader).toHaveBeenCalledTimes(2);
      expect(generateExcelFile).toHaveBeenCalledWith(mockReportResult);
      expect(result).toEqual({ excelBuffer: mockExcelBuffer, statusCode: 200 });
    });
  });

  describe('downloadFilteredReportService', () => {
    afterEach(() => {
      jest.clearAllMocks();
    });

    it('should download a filtered report', async () => {
      const mockRes = {
        setHeader: jest.fn(),
      };
      const mockReport = { data: 'filteredTestData' };
      const mockExcelBuffer = Buffer.from('mock filtered excel data');

      generateExcelFile.mockResolvedValue({ excelBuffer: mockExcelBuffer, statusCode: 200 });

      const result = await downloadFilteredReportService(mockRes, mockReport);

      expect(mockRes.setHeader).toHaveBeenCalledTimes(2);
      expect(generateExcelFile).toHaveBeenCalledWith(mockReport);
      expect(result).toEqual({ excelBuffer: mockExcelBuffer, statusCode: 200 });
    });
  });

  describe('getReportService', () => {
    it('should get a report by id', async () => {
      const mockId = '123';
      const mockReportInfo = { id: '123', name: 'Test Report' };
      const mockReportParams = [{ param1: 'value1' }];

      reportsQueries.getReportById.mockResolvedValue({ report_info: mockReportInfo, report_params: mockReportParams });
      cacheQuery.mockResolvedValueOnce({ report_info: mockReportInfo, report_params: mockReportParams });

      const result = await getReportService(mockId);

      expect(result).toEqual({
        report_info: mockReportInfo,
        report_params: [{ param1: 'value1' }],
      });
    });
  });

  describe('searchProcedureService', () => {
    it('should search for a procedure', async () => {
      const mockProcedureName = 'testProcedure';
      const mockProcedureInfo = { name: 'testProcedure', description: 'Test procedure' };
      const mockProcedureParams = [{ param1: 'value1' }];

      reportsQueries.getProcedureInfo.mockResolvedValue({
        procedure_info: mockProcedureInfo,
        procedure_params: mockProcedureParams,
        statusCode: 200,
      });

      const result = await searchProcedureService(mockProcedureName);

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
      const mockProcedure = { name: 'testProcedure', params: [{ param1: 'value1' }] };
      const mockCreatedReport = { id: '123', name: 'Test Report' };

      reportsQueries.createReport.mockResolvedValue({ createdReport: mockCreatedReport, statusCode: 201 });

      const result = await createReportService(mockProcedure);

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

      const result = await updateReportService(mockId, mockReport);

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

      const result = await deleteReportService(mockId);

      expect(delKey).toHaveBeenCalledWith(`get-report-${mockId}`);
      expect(reportsQueries.deleteReport).toHaveBeenCalledWith(mockId);
      expect(result).toEqual({ deletedReport: mockDeletedReport, statusCode: 200 });
    });
  });
});
