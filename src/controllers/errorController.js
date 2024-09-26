const AppError = require('../utils/AppError');
const logger = require('../logging/winstonSetup');

module.exports = errorHandler = (err, req, res, next) => {
  const handled_err = handleOtherErrors(err);
  const error = handled_err || err;

  console.log('Test Error log', error);
  res.status(error.statusCode || 500).json({
    status: error.status,
    statusMessage:
      error.statusMessage === 'error-executing-query'
        ? error.message.includes('-')
          ? error.message.split(' ').pop()
          : error.statusMessage
        : error.statusMessage,
    message: error.message,
    statusCode: error.statusCode,
    error: error.name,
  });

  logger.error(`${error.status} - ${error.message} - ${error.statusMessage}- ${req.originalUrl} - ${req.method} - ${req.ip}`);

  next();
};

const handleOtherErrors = (err) => {
  if (err.name === 'TokenExpiredError') return handleTokenExpiredError();
  if (err.name === 'TypeCastError') return handleTypeCastError();
  if (err.name === 'JsonWebTokenError') return handleJWTError();
  return null;
};

const handleJWTError = () => new AppError('Invalid token. Please log in again!', 401, 'error-invalid-token');

const handleTokenExpiredError = () => new AppError('Your token has expired! Please log in again.', 401, 'error-expired-token');

const handleTypeCastError = () => new AppError('Invalid ID', 400, 'error-invalid-id');
