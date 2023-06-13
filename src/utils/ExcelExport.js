const xlsx = require('xlsx');

module.exports = generateExcelFile = async (data) => {
  try {
    const wb = xlsx.utils.book_new();
    const ws = xlsx.utils.json_to_sheet(data);

    xlsx.utils.book_append_sheet(wb, ws, 'Sheet1');

    return {
      excelBuffer: xlsx.write(wb, { bookType: 'xlsx', type: 'buffer' })
    };
  } catch (err) {
    console.log('Error generating excel file');
    console.log(err);
    throw err;
  }
};
