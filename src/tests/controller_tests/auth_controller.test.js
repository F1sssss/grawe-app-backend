const authController = require('../../controllers/authController');
const authServices = require('../../services/authService');
const userServices = require('../../services/userService');
const responseHandler = require('../../utils/responseHandler');
const AppError = require('../../utils/AppError');

jest.mock('../../services/authService');
jest.mock('../../services/userService');
jest.mock('../../utils/responseHandler');

describe('Auth Controller', () => {
  let mockReq, mockRes, mockNext;

  beforeEach(() => {
    mockReq = { body: {}, query: {}, secure: true, headers: {} };
    mockRes = {
      cookie: jest.fn(),
      status: jest.fn().mockReturnThis(),
      send: jest.fn(),
      json: jest.fn(),
    };
    mockNext = jest.fn();
  });

  afterEach(() => {
    jest.clearAllMocks();
  });

  describe('login', () => {
    it('should set cookie and send response', async () => {
      const mockLoginResponse = {
        token: 'test-token',
        user: { id: 1, username: 'testuser' },
        statusCode: 200,
      };
      authServices.loginService.mockResolvedValue(mockLoginResponse);

      await authController.login(mockReq, mockRes);

      expect(mockRes.cookie).toHaveBeenCalledWith('token', 'test-token', expect.any(Object));
      expect(mockRes.status).toHaveBeenCalledWith(200);
      expect(mockRes.send).toHaveBeenCalledWith({
        message: 'Login successful!',
        token: 'test-token',
        user: { id: 1, username: 'testuser' },
      });
    });
  });

  describe('logout', () => {
    it('should clear cookie', async () => {
      await authController.logout(mockReq, mockRes);

      expect(mockRes.cookie).toHaveBeenCalledWith('token', 'loggedOut', expect.any(Object));
      expect(mockRes.status).toHaveBeenCalledWith(200);
      expect(mockRes.json).toHaveBeenCalledWith({ status: 'success' });
    });
  });

  describe('signUp', () => {
    it('should call responseHandler with correct arguments', async () => {
      const mockSignupResponse = { user: { id: 1, username: 'newuser' } };
      authServices.signupService.mockResolvedValue(mockSignupResponse);

      await authController.signUp(mockReq, mockRes);

      expect(responseHandler).toHaveBeenCalledWith(expect.any(Promise), mockRes, { statusCode: 201 });
    });
  });

  describe('forgotPassword', () => {
    it('should call responseHandler with correct arguments', async () => {
      const mockForgotPasswordResponse = { message: 'Password reset email sent' };
      authServices.forgotPasswordService.mockResolvedValue(mockForgotPasswordResponse);
      mockReq.body.username = 'testuser';

      await authController.forgotPassword(mockReq, mockRes);

      expect(responseHandler).toHaveBeenCalledWith(expect.any(Promise), mockRes, { statusCode: 200 });
    });
  });

  describe('setNewPassword', () => {
    it('should call responseHandler with correct arguments', async () => {
      const mockSetNewPasswordResponse = { message: 'Password updated successfully' };
      authServices.setNewPasswordService.mockResolvedValue(mockSetNewPasswordResponse);
      mockReq.body.newPassword = 'newpassword123';
      mockReq.query.id = '1';

      await authController.setNewPassword(mockReq, mockRes);

      expect(responseHandler).toHaveBeenCalledWith(expect.any(Promise), mockRes, { statusCode: 200 });
    });
  });

  describe('emailVerification', () => {
    it('should call responseHandler with correct arguments', async () => {
      const mockVerifyUserResponse = { message: 'Email verified successfully' };
      authServices.verifyUserService.mockResolvedValue(mockVerifyUserResponse);
      mockReq.query.id = '1';
      mockReq.query.token = 'verificationtoken123';

      await authController.emailVerification(mockReq, mockRes);

      expect(responseHandler).toHaveBeenCalledWith(expect.any(Promise), mockRes, { statusCode: 200 });
    });
  });

  describe('protect middleware', () => {
    it('should set user on request object', async () => {
      const mockUser = { id: 1, username: 'testuser' };
      userServices.getMeService.mockResolvedValue({ user: mockUser });

      await authController.protect(mockReq, mockRes, mockNext);

      expect(mockReq.user).toEqual(mockUser);
      expect(mockNext).toHaveBeenCalled();
    });
  });
});
