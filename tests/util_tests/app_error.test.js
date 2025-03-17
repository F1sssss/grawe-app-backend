const AppError = require('../../src/utils/AppError');

describe('AppError', () => {
  it('should create an instance with correct properties', () => {
    const message = 'Test error message';
    const statusCode = 400;
    const statusMessage = 'Bad Request';

    const error = new AppError(message, statusCode, statusMessage);

    expect(error).toBeInstanceOf(Error);
    expect(error).toBeInstanceOf(AppError);
    expect(error.message).toBe(message);
    expect(error.statusCode).toBe(statusCode);
    expect(error.statusMessage).toBe(statusMessage);
    expect(error.isOperational).toBe(true);
    expect(error.stack).toBeDefined();
  });
});
