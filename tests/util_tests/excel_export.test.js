const generateExcelFile = require('../../utils/Exports/ExcelExport');
const xlsx = require('xlsx');
const AppError = require('../../utils/AppError');

jest.mock('xlsx');
jest.mock('../../utils/AppError');
jest.mock('../../logging/winstonSetup');

describe('ExcelExport', () => {
  beforeEach(() => {
    jest.clearAllMocks();
  });

  it('should generate an Excel file successfully', async () => {
    const mockData = [{ name: 'John Doe', age: 30 }];
    const mockWorkbook = {};
    const mockWorksheet = {};
    const mockBuffer = Buffer.from('mock excel data');

    xlsx.utils.book_new.mockReturnValue(mockWorkbook);
    xlsx.utils.json_to_sheet.mockReturnValue(mockWorksheet);
    xlsx.write.mockReturnValue(mockBuffer);

    const result = await generateExcelFile(mockData);

    expect(result).toEqual({
      excelBuffer: mockBuffer,
      statusCode: 200,
    });
    expect(xlsx.utils.book_new).toHaveBeenCalled();
    expect(xlsx.utils.json_to_sheet).toHaveBeenCalledWith(mockData);
    expect(xlsx.utils.book_append_sheet).toHaveBeenCalledWith(mockWorkbook, mockWorksheet, 'Sheet1');
    expect(xlsx.write).toHaveBeenCalledWith(mockWorkbook, { bookType: 'xlsx', type: 'buffer' });
  });

  it('should throw an AppError if Excel file generation fails', async () => {
    const mockData = [{ name: 'John Doe', age: 30 }];

    xlsx.write.mockReturnValueOnce(null); // Simulate failure on first call
    xlsx.write.mockReturnValueOnce(Buffer.from('mock excel data')); // Succeed on second call

    try {
      await generateExcelFile(mockData);
    } catch (error) {
      expect(error).toBeInstanceOf(AppError);
    }
  });
});
