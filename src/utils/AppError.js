module.exports = class AppError extends Error {
  constructor(message, statusCode, statusMessage) {
    super(message);

    this.statusCode = statusCode;
    this.statusMessage = statusMessage;
    this.message = message;
    this.isOperational = true;

    Error.captureStackTrace(this, this.constructor);
  }
};
