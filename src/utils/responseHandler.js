const AppError = require('./AppError');

const handleResponse = async (promise, res, responseFields = {}, message = 'success', next) => {
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
  const { statusCode, ...fields } = responseFields;

  if (!data || data.length === 0) {
    throw new AppError('No data found', 404, 'error-controller-handler-no-data-found');
  }

  res.status(statusCode).json({
    status: message,
    data,
    ...fields,
  });
};

function getValue(obj, keyPath) {
  return keyPath.reduce((acc, curr) => {
    return acc && acc[curr];
  }, obj);
}

module.exports = handleResponse;
