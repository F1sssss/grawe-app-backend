const jwt = require('jsonwebtoken');
const bcrypt = require('bcryptjs');
const AdAuth = require('../../utils/ADConnection');
const SQLQueries = require('../../sql/Queries/UserQueries');
const EmailValidator = require('../../utils/Email/Email');
const authService = require('../../services/authService');
const AppError = require('../../utils/AppError');

// Mocking the necessary modules
jest.mock('jsonwebtoken');
jest.mock('bcryptjs');
jest.mock('../../utils/ADConnection');
jest.mock('../../sql/Queries/UserQueries');
jest.mock('../../utils/Email/Email');

describe('User Services', () => {
  afterEach(() => {
    jest.clearAllMocks();
  });

  describe('loginService', () => {
    it('should authenticate user via AD and return a token', async () => {
      const mockUser = { username: 'testUser', password: 'hashedPassword' };
      const token = 'fakeToken';

      AdAuth.authenticateUser.mockResolvedValue(mockUser);
      jwt.sign.mockReturnValue(token);

      const result = await authService.loginService('testUser', 'password123');

      expect(AdAuth.authenticateUser).toHaveBeenCalledWith('testUser', 'password123');
      expect(jwt.sign).toHaveBeenCalledWith({ username: 'testUser' }, expect.anything(), expect.anything());
      expect(result).toEqual({ token, user: { ...mockUser, password: undefined }, statusCode: 200 });
    });

    it('should authenticate user via local database and return a token', async () => {
      const mockUser = { username: 'testUser', password: 'hashedPassword' };
      const token = 'fakeToken';

      AdAuth.authenticateUser.mockRejectedValue(new Error('AD Authentication Failed'));
      SQLQueries.getUserByUsernameOrEmail.mockResolvedValue({ user: mockUser });
      bcrypt.compare.mockResolvedValue(true); // Mock password match
      jwt.sign.mockReturnValue(token);

      const result = await authService.loginService('testUser', 'password123');

      expect(SQLQueries.getUserByUsernameOrEmail).toHaveBeenCalledWith('testUser', 'testUser', 'login');
      expect(bcrypt.compare).toHaveBeenCalledWith('password123', 'hashedPassword');
      expect(result).toEqual({ token, user: { ...mockUser, password: undefined }, statusCode: 200 });
    });

    it('should throw error for invalid password', async () => {
      const mockUser = { username: 'testUser', password: 'hashedPassword' };

      AdAuth.authenticateUser.mockRejectedValue(new Error('AD Authentication Failed'));
      SQLQueries.getUserByUsernameOrEmail.mockResolvedValue({ user: mockUser });
      bcrypt.compare.mockResolvedValue(false); // Mock password mismatch

      await expect(authService.loginService('testUser', 'wrongPassword')).rejects.toThrow('Invalid Password');
    });
  });

  describe('signupService', () => {
    it('should create a new user and send a verification email', async () => {
      const mockRequest = { username: 'newUser', email: 'test@example.com', password: 'Password123!' };
      const mockUser = { id: 1, username: 'newUser', email: 'test@example.com' };
      const emailMock = {
        sendEmailVerification: jest.fn(),
      };

      SQLQueries.createUser.mockResolvedValue({ user: mockUser });
      bcrypt.hash.mockResolvedValue('hashedPassword');
      EmailValidator.mockImplementation(() => emailMock);

      const result = await authService.signupService(mockRequest);

      expect(SQLQueries.createUser).toHaveBeenCalledWith({ ...mockRequest, password: 'hashedPassword' });
      expect(emailMock.sendEmailVerification).toHaveBeenCalled();
      expect(result).toEqual({ message: 'User created successfully!', user: mockUser, statusCode: 201 });
    });
  });

  describe('forgotPasswordService', () => {
    it('should send password retrieval email', async () => {
      const mockUser = { id: 1, email: 'test@example.com' };
      const emailMock = {
        sendEmailRetrievingPassword: jest.fn(),
      };

      SQLQueries.getUserByUsernameOrEmail.mockResolvedValue({ user: mockUser });
      EmailValidator.mockImplementation(() => emailMock);

      const result = await authService.forgotPasswordService(1);

      expect(SQLQueries.getUserByUsernameOrEmail).toHaveBeenCalledWith(1);
      expect(emailMock.sendEmailRetrievingPassword).toHaveBeenCalled();
      expect(result).toEqual({ user: mockUser, statusCode: 200 });
    });
  });

  describe('verifyUserService', () => {
    it('should verify a user by checking the token', async () => {
      const mockUser = { id: 1, email: 'test@example.com', verified: false, email_verification_token: 'validToken' };

      // Make sure the mock returns an object containing `user`
      SQLQueries.getUserById.mockResolvedValue({ user: mockUser, email_verification_token: 'validToken' });
      authService.checkVerificationToken = jest.fn().mockResolvedValue({ user: mockUser, email_verification_token: 'validToken' });
      SQLQueries.updateUserVerification.mockResolvedValue(true);

      const result = await authService.verifyUserService(1, 'validToken');

      expect(SQLQueries.updateUserVerification).toHaveBeenCalledWith(1, 1);
      expect(result).toEqual({ user: mockUser, statusCode: 200 });
    });
  });

  describe('setNewPasswordService', () => {
    it('should update the user password', async () => {
      bcrypt.hash.mockResolvedValue('hashedNewPassword');
      SQLQueries.updateUserPassword.mockResolvedValue({ new_value: 'hashedNewPassword', statusCode: 200 });

      const result = await authService.setNewPasswordService('newPassword123', 1);

      expect(bcrypt.hash).toHaveBeenCalledWith('newPassword123', 12);
      expect(SQLQueries.updateUserPassword).toHaveBeenCalledWith(1, 'hashedNewPassword');
      expect(result).toEqual({ new_value: 'hashedNewPassword', statusCode: 200 });
    });
  });

  describe('signupFieldValidationService', () => {
    it('should validate the input fields for signup', async () => {
      const mockRequest = { username: 'validUser', email: 'test@example.com', password: 'Password123!' };

      SQLQueries.getUserByUsernameOrEmail.mockResolvedValue({ user: null });

      const result = await authService.signupFieldValidationService(mockRequest);

      expect(result).toEqual({ message: 'Valid parameters!', statusCode: 200 });
    });

    it('should throw an error if username already exists', async () => {
      const mockRequest = { username: 'existingUser', email: 'test@example.com', password: 'Password123!' };
      const mockUser = { username: 'existingUser' };

      SQLQueries.getUserByUsernameOrEmail.mockResolvedValue({ user: mockUser });

      await expect(authService.signupFieldValidationService(mockRequest)).rejects.toThrow('Username already exists');
    });

    it('should throw an error for invalid username', async () => {
      const mockRequest = { username: 'invalid!', email: 'test@example.com', password: 'Password123!' };

      await expect(authService.signupFieldValidationService(mockRequest)).rejects.toThrow('Invalid Username');
    });
  });
});
