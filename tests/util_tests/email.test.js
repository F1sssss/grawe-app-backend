const Email = require('../../src/utils/Email/Email');
const sgMail = require('@sendgrid/mail');
const logger = require('../../src/logging/winstonSetup');

jest.mock('@sendgrid/mail');
jest.mock('../../src/logging/winstonSetup');

describe('Email', () => {
  const mockUser = {
    email: 'test@example.com',
    username: 'testuser',
    ID: '123',
    email_verification_token: 'token123',
  };

  beforeEach(() => {
    process.env.SENDGRID_API_KEY = 'mock_api_key';
    process.env.EMAIL_FROM = 'from@example.com';
    process.env.FRONTEND_URL = 'http://frontend.com';
    process.env.HOST_URL = 'http://host.com';
    jest.clearAllMocks();
  });

  describe('sendEmailVerification', () => {
    it('should send a verification email successfully', async () => {
      const email = new Email(mockUser);
      sgMail.send.mockResolvedValue();

      const result = await email.sendEmailVerification();

      expect(result).toEqual({ message: 'Email sent successfully!', statusCode: 200 });
    });

    it('should handle errors when sending verification email', async () => {
      const email = new Email(mockUser);
      const mockError = new Error('Send failed');
      sgMail.send.mockRejectedValue(mockError);

      const result = await email.sendEmailVerification();

      expect(logger.error).toHaveBeenCalledWith(mockError);
      expect(result).toEqual({ message: 'Email sent successfully!', statusCode: 200 });
    });
  });

  describe('sendEmailRetrievingPassword', () => {
    it('should send a password reset email successfully', async () => {
      const email = new Email(mockUser);
      sgMail.send.mockResolvedValue();

      const result = await email.sendEmailRetrievingPassword();

      expect(result).toEqual({ message: 'Email sent successfully!', statusCode: 200 });
    });

    it('should handle errors when sending password reset email', async () => {
      const email = new Email(mockUser);
      const mockError = new Error('Send failed');
      sgMail.send.mockRejectedValue(mockError);

      const result = await email.sendEmailRetrievingPassword();

      expect(logger.error).toHaveBeenCalledWith(mockError);
      expect(result).toEqual({ message: 'Email sent successfully!', statusCode: 200 });
    });
  });
});
