const AppError = require('./AppError');
const logger = require('../logging/winstonSetup');

const handleResponse = async (promise, res, responseFields = {}, next) => {
  let data = await promise;

  /*
  const filteredObject = {};

  res.FilterFields.forEach((key) => {
    const keyPath = key.split('/'); // Split key by "/"
    let value = data;

    keyPath.forEach((path) => {
      if (value[path]) {
        value = value[path];
      } else {
        value[path] = {};
        value = value[path];
      }
    });

    if (value !== undefined) {
      filteredObject[keyPath[keyPath.length - 1]] = getValue(data, keyPath); // Add value to filtered object with last key
    }
  });

  console.log('filteredObject', filteredObject);
*/

  // if (!data || data.length === 0) {
  //   throw new AppError('No data found', 404, 'error-controller-handler-no-data-found');
  // }

  delete data.statusCode;

  res.status(200).json(Object.keys(data).length > 1 ? data : data[Object.keys(data)[0]] || data);
};

function getValue(obj, keyPath) {
  return keyPath.reduce((acc, curr) => {
    return acc && acc[curr];
  }, obj);
}

module.exports = handleResponse;
