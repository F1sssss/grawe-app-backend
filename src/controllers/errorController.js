module.exports = errorHandler = (err, req, res, next) => {
  res.status(err.statusCode || 500).json({
    status: err.status,
    statusMessage: err.statusMessage,
    message: err.message,
    statusCode: err.statusCode,
    error: err.name
  });
  next();
};
