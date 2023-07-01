// Desc: Error handler for the application

const AppError = require('../utils/appError');

module.exports = errorHandler = (err, req, res, next) => {
  handleOtherErrors(err, res);

  res.status(err.statusCode || 500).json({
    status: err.status,
    statusMessage: err.statusMessage,
    message: err.message,
    statusCode: err.statusCode,
    error: err.name,
  });
  next();
};

const handleOtherErrors = (err) => {
  if (err.name === 'TokenExpiredError') handleTokenExpiredError(err);
  if (err.name === 'TypeCastError') handleTypeCastError(err);
  if (err.name === 'JsonWebTokenError') handleJWTError(err);
};

const handleJWTError = () => new AppError('Invalid token. Please log in again!', 401, 'error-invalid-token');

const handleTokenExpiredError = () => new AppError('Your token has expired! Please log in again.', 401, 'error-expired-token');

const handleTypeCastError = () => new AppError('Invalid ID', 400, 'error-invalid-id');
