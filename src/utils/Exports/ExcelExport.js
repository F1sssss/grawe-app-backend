const ExcelJS = require('exceljs');
const AppError = require('../AppError');
const logger = require('../../logging/winstonSetup');

module.exports = generateExcelFile = async (data) => {
  try {
    const workbook = new ExcelJS.Workbook();
    const worksheet = workbook.addWorksheet('Sheet1');

    // Add headers
    if (data.length > 0) {
      worksheet.columns = Object.keys(data[0]).map((key) => ({ header: key, key }));
    }

    // Add rows
    worksheet.addRows(data);

    logger.info('Excel file generated', { label: 'ExcelExport' });

    // Generate buffer
    const buffer = await workbook.xlsx.writeBuffer();

    return {
      excelBuffer: buffer,
      statusCode: 200,
    };
  } catch (error) {
    logger.error('Error generating excel file', { label: 'ExcelExport', error });
    throw new AppError('Error generating excel file', 500, 'error-generating-excel-file');
  }
};
