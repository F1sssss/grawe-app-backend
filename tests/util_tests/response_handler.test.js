const handleResponse = require('../../src/utils/responseHandler');

describe('handleResponse', () => {
  let mockRes;

  beforeEach(() => {
    mockRes = {
      status: jest.fn().mockReturnThis(),
      json: jest.fn(),
    };
  });

  it('should send a successful response with data', async () => {
    const mockData = { id: 1, name: 'Test' };
    const mockPromise = Promise.resolve(mockData);

    await handleResponse(mockPromise, mockRes);

    expect(mockRes.status).toHaveBeenCalledWith(200);
    expect(mockRes.json).toHaveBeenCalledWith(mockData);
  });

  it('should send a single value if data has only one key', async () => {
    const mockData = { singleKey: 'singleValue' };
    const mockPromise = Promise.resolve(mockData);

    await handleResponse(mockPromise, mockRes);

    expect(mockRes.status).toHaveBeenCalledWith(200);
    expect(mockRes.json).toHaveBeenCalledWith('singleValue');
  });

  it('should remove statusCode from the response data', async () => {
    const mockData = { id: 1, name: 'Test', statusCode: 200 };
    const mockPromise = Promise.resolve(mockData);

    await handleResponse(mockPromise, mockRes);

    expect(mockRes.status).toHaveBeenCalledWith(200);
    expect(mockRes.json).toHaveBeenCalledWith({ id: 1, name: 'Test' });
  });

  it('should handle errors thrown by the promise', async () => {
    const mockError = new Error('Test error');
    const mockPromise = Promise.reject(mockError);
    const mockNext = jest.fn();

    await expect(handleResponse(mockPromise, mockRes, {}, mockNext)).rejects.toThrow('Test error');
  });
});
