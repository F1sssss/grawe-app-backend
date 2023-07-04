const reportsQueries = require('../../sql/Queries/reportsQueries');
let cacheQuery = require('../../utils/cacheQuery');
let {
  getReportService,
  searchProcedureService,
  createReportService,
  updateReportService,
  executeReport,
  generateReportService,
} = require('../reportsService');

jest.mock('../../sql/Queries/reportsQueries');
jest.mock('../../sql/Queries/params');
jest.mock('../../utils/cacheQuery');

describe('reports services tests', () => {
  it('should get a report', async () => {
    reportsQueries.getReportById.mockReturnValue({ report_info: { polisa: 'polisa' }, report_params: [{ param: 'param', order: 1 }] });
    cacheQuery.mockReturnValue({ report_info: { polisa: 'polisa' }, report_params: [{ param: 'param', order: 1 }] });
    const { report_info, report_params } = await getReportService(1);
    expect(report_info.polisa).toEqual('polisa');
  });

  it('should execute report and return report result and status code', async () => {
    const reportInfo = {
      procedure_name: 'report1',
    };
    const reportParams = {
      param1: 'value1',
      param2: 'value2',
    };
    const inputParams = {
      input1: 'value1',
      input2: 'value2',
    };
    const cacheKey = `execute-report-${reportInfo.procedure_name}-${JSON.stringify(inputParams)}-${JSON.stringify(reportParams)}`;
    const queryParams = {
      param1: 'value1',
      param2: 'value2',
    };
    const expectedReportResult = {
      result: 'report result',
    };
    const expectedStatusCode = 200;

    cacheQuery.mockResolvedValue({ reportResult: expectedReportResult, statusCode: expectedStatusCode });

    const result = await executeReport(reportInfo, reportParams, inputParams);

    expect(cacheQuery).toHaveBeenCalledWith(cacheKey, reportsQueries.executeReport(reportInfo.procedure_name, queryParams));
    expect(result).toEqual({ reportResult: expectedReportResult, statusCode: expectedStatusCode });
  });

  it('should search a procedure', async () => {
    reportsQueries.getProcedureInfo.mockReturnValue({ procedure_info: { polisa: 'polisa' }, procedure_params: [{ param: 'param', order: 1 }] });
    const { procedure_info, procedure_params } = await searchProcedureService('procedure_name');
    expect(procedure_info.polisa).toEqual('polisa');
  });

  it('should create a report', async () => {
    reportsQueries.createReport.mockReturnValue({ procedure_info: { polisa: 'polisa' }, procedure_params: [{ param: 'param', order: 1 }] });
    const { procedure_info, procedure_params } = await createReportService({
      procedure_info: { polisa: 'polisa' },
      procedure_params: [{ param: 'param', order: 1 }],
    });
    expect(procedure_info.polisa).toEqual('polisa');
  });

  it('should update a report', async () => {
    reportsQueries.updateReport.mockReturnValue({ procedure_info: { polisa: 'polisa' }, procedure_params: [{ param: 'param', order: 1 }] });
    const { procedure_info, procedure_params } = await updateReportService({
      procedure_info: { polisa: 'polisa' },
      procedure_params: [{ param: 'param', order: 1 }],
    });
    expect(procedure_info.polisa).toEqual('polisa');
  });
});
