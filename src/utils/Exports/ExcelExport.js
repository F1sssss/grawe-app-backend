const xlsx = require('xlsx');
const AppError = require('../AppError');
const logger = require('../../logging/winstonSetup');

module.exports = generateExcelFile = async (data) => {
  const wb = xlsx.utils.book_new();
  const ws = xlsx.utils.json_to_sheet(data);

  xlsx.utils.book_append_sheet(wb, ws, 'Sheet1');

  logger.info('Excel file generated', { label: 'ExcelExport' });

  if (!xlsx.write(wb, { bookType: 'xlsx', type: 'buffer' })) {
    logger.error('Error generating excel file', { label: 'ExcelExport' });
    throw new AppError('Error generating excel file', 500, 'error-generating-excel-file');
  }

  return {
    excelBuffer: xlsx.write(wb, { bookType: 'xlsx', type: 'buffer' }),
    statusCode: 200,
  };
};
