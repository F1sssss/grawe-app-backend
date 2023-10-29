const AppError = require('./AppError');

const handleResponse = async (promise, res, responseFields = {}, message = 'success') => {
  let data = await promise;

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

module.exports = handleResponse;
