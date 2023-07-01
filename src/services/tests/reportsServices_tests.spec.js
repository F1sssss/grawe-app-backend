const reportsQueries = require('../../sql/Queries/reportsQueries');
const params = require('../../sql/Queries/params');
const cacheQuery = require('../../utils/cacheQuery');
const { getReportService, searchProcedureService, createReportService, updateReportService } = require('../reportsService');

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
