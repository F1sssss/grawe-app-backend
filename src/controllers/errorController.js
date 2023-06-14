module.exports = errorHandler = (err, req, res, next) => {
  res.json({
    status: err.status,
    statusMessage: err.statusMessage,
    message: err.message,
    statusCode: err.statusCode,
    error: err.name
  });
  next();
};
