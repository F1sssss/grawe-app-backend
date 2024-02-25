const AppError = require('../AppError');
const catchAsync = require('../../middlewares/CatchAsync');

const Email = require('../Email/Email');
const sgMail = require('@sendgrid/mail');
const emailRegister = require('../EmailTemplates/emailRegister');
const emailForgotPassword = require('../EmailTemplates/emailForgotPassword');

jest.mock('@sendgrid/mail');

describe('Email', () => {
  beforeAll(() => {});

  beforeEach(() => {
    // Clear mock function calls before each test
    jest.clearAllMocks();
    sgMail.setApiKey.mockReturnValue(true);
  });

  it('should send email verification successfully', async () => {
    const user = {
      email: 'test@example.com',
      username: 'testuser',
      ID: 'user-id',
      email_verification_token: 'verification-token',
    };

    const emailInstance = new Email(user);

    // Mock the send function to resolve successfully
    sgMail.send.mockResolvedValue(true);

    const result = await emailInstance.sendEmailVerification();

    expect(sgMail.send).toHaveBeenCalledWith({
      to: 'test@example.com',
      from: 'test@example.com',
      subject: '[GRAWE] Verification email',
      html: expect.stringContaining('Verification/?id=user-id?token=verification-token'),
    });

    expect(result).toEqual({ message: 'Email sent successfully!', statusCode: 200 });
  });

  it('should throw an error if sending email verification fails', async () => {
    const user = {
      email: 'test@example.com',
      username: 'testuser',
      ID: 'user-id',
      email_verification_token: 'verification-token',
    };

    const emailInstance = new Email(user);

    // Mock the send function to reject with an error
    sgMail.send.mockRejectedValue(new AppError('Test error'));

    await expect(emailInstance.sendEmailVerification()).rejects.toThrow(AppError);
  });

  // Add similar test cases for `sendEmailRetrievingPassword()` method
});

describe('catchAsync', () => {
  it('should call the provided function and catch rejections', async () => {
    const req = {}; // Mock request object
    const res = {}; // Mock response object
    const next = jest.fn(); // Mock next middleware function

    // Mock function that returns a promise and throws an error
    const asyncFunction = jest.fn().mockRejectedValue(new Error('Test error'));

    const wrappedFunction = catchAsync(asyncFunction);

    // Call the wrapped function
    await wrappedFunction(req, res, next);

    expect(asyncFunction).toHaveBeenCalledWith(req, res, next);
    expect(next).toHaveBeenCalled();

    // Ensure that next is called with the error
    const errorArgument = next.mock.calls[0][0];
    expect(errorArgument).toBeInstanceOf(Error);
    expect(errorArgument.message).toBe('Test error');
  });

  // You can add more test cases to cover other scenarios if needed
});
describe('AppError', () => {
  it('should set the correct properties when creating an instance', () => {
    const errorMessage = 'Test error message';
    const statusCode = 404;
    const statusMessage = 'Not Found';

    const error = new AppError(errorMessage, statusCode, statusMessage);

    expect(error.message).toBe(errorMessage);
    expect(error.statusCode).toBe(statusCode);
    expect(error.statusMessage).toBe(statusMessage);
    expect(error.isOperational).toBe(true);
  });

  it('should have a stack trace captured', () => {
    const errorMessage = 'Test error message';
    const statusCode = 500;
    const statusMessage = 'Internal Server Error';

    const error = new AppError(errorMessage, statusCode, statusMessage);

    // Ensure that a stack trace is captured
    expect(error.stack).toBeDefined();
  });

  it('should have isOperational set to true', () => {
    const errorMessage = 'Test error message';
    const statusCode = 400;
    const statusMessage = 'Bad Request';

    const error = new AppError(errorMessage, statusCode, statusMessage);

    expect(error.isOperational).toBe(true);
  });
});
