const errorHandler = require('../../controllers/errorController');
const AppError = require('../../utils/AppError');
const logger = require('../../logging/winstonSetup');

jest.mock('../../logging/winstonSetup');

describe('Error Controller', () => {
  let mockReq, mockRes, mockNext;

  beforeEach(() => {
    mockReq = { originalUrl: '/test', method: 'GET', ip: '127.0.0.1' };
    mockRes = { status: jest.fn().mockReturnThis(), json: jest.fn() };
    mockNext = jest.fn();
  });

  afterEach(() => {
    jest.clearAllMocks();
  });

  describe('handleOtherErrors', () => {
    it('should handle AppError correctly', () => {
      const appError = new AppError('Test error', 400, 'error-test');

      errorHandler(appError, mockReq, mockRes, mockNext);

      expect(mockRes.status).toHaveBeenCalledWith(400);
      expect(mockRes.json).toHaveBeenCalledWith({
        statusMessage: 'error-test',
        message: 'Test error',
        statusCode: 400,
        error: 'Error',
      });
      expect(logger.error).toHaveBeenCalled();
    });

    it('should handle TokenExpiredError correctly', () => {
      const tokenError = new Error('Token expired');
      tokenError.name = 'TokenExpiredError';

      errorHandler(tokenError, mockReq, mockRes, mockNext);

      expect(mockRes.status).toHaveBeenCalledWith(401);
      expect(mockRes.json).toHaveBeenCalledWith(
        expect.objectContaining({
          statusMessage: 'error-expired-token',
          message: 'Your token has expired! Please log in again.',
        }),
      );
    });

    it('should handle TypeCastError correctly', () => {
      const typeCastError = new Error('Invalid type');
      typeCastError.name = 'TypeCastError';

      errorHandler(typeCastError, mockReq, mockRes, mockNext);

      expect(mockRes.status).toHaveBeenCalledWith(400);
      expect(mockRes.json).toHaveBeenCalledWith(
        expect.objectContaining({
          statusMessage: 'error-invalid-id',
          message: 'Invalid ID',
        }),
      );
    });

    it('should handle JsonWebTokenError correctly', () => {
      const jwtError = new Error('Invalid token');
      jwtError.name = 'JsonWebTokenError';

      errorHandler(jwtError, mockReq, mockRes, mockNext);

      expect(mockRes.status).toHaveBeenCalledWith(401);
      expect(mockRes.json).toHaveBeenCalledWith(
        expect.objectContaining({
          statusMessage: 'error-invalid-token',
          message: 'Invalid token. Please log in again!',
        }),
      );
    });

    it('should handle unknown errors correctly', () => {
      const unknownError = new Error('Unknown error');

      errorHandler(unknownError, mockReq, mockRes, mockNext);

      expect(mockRes.status).toHaveBeenCalledWith(500);
      expect(mockRes.json).toHaveBeenCalledWith(
        expect.objectContaining({
          message: 'Unknown error',
        }),
      );
    });
  });

  describe('error logging', () => {
    it('should log errors correctly', () => {
      const error = new Error('Test error');

      errorHandler(error, mockReq, mockRes, mockNext);

      expect(logger.error).toHaveBeenCalledWith(expect.stringContaining('Test error'));
    });
  });
});
