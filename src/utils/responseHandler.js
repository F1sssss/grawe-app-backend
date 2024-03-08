const AppError = require('./AppError');
const logger = require('../logging/winstonSetup');

const handleResponse = async (promise, res, responseFields = {}) => {
  logger.debug('Got a promise in handleResponse, waiting for it to resolve...');

  let data = await promise;

  logger.debug('Promise resolved!');

  logger.debug('Filtering response...');

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

  const { statusCode } = responseFields;

  if (!data || data.length === 0) {
    throw new AppError('No data found', 404, 'error-controller-handler-no-data-found');
  }

  delete data.statusCode;

  logger.debug('Response filtered!');

  logger.debug('Sending response...');

  //console.log(data);

  res.status(statusCode).json(Object.keys(data).length > 1 ? data : data[Object.keys(data)[0]] || data);
};

function getValue(obj, keyPath) {
  return keyPath.reduce((acc, curr) => {
    return acc && acc[curr];
  }, obj);
}

module.exports = handleResponse;
