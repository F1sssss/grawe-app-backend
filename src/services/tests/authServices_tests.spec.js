const authService = require('../authService');
const { getUserByUsernameOrEmail, createUser, getUserById, updateUserVerification, updateUserPassword } = require('../../sql/Queries/UserQueries');
const Email = require('../../utils/Email/Email');
let {
  signupService,
  loginService,
  forgotPasswordService,
  checkVerificationToken,
  verifyUserService,
  setNewPasswordService,
  signupFieldValidationService,
} = authService;
const bcryptjs = require('bcryptjs');

jest.mock('../../sql/Queries/UserQueries');
jest.mock('bcryptjs');
jest.mock('../../utils/Email/Email');

const mockUser = {
  user: {
    ID: 2,
    username: 'filip123',
    password: '$2a$12$pe8NUBi4sPNjnWuW9Lp8ye/JdK1GJzvZED2W87nLRLnmJZJcnNLi.',
    name: 'Filip',
    last_Name: 'Stankovic',
    date_of_birth: '1999.01.11',
    role: null,
    email: 'filips385@rocketmail.com',
    verified: 1,
    time_to_varify: new Date('2023-06-25T11:27:50.277Z'),
    created_at: new Date(' 2023-06-25T11:27:50.277Z'),
    updated_at: null,
    email_verification_token: 225946481,
  },
};

describe('authentication service tests', () => {
  it('should login a user', async () => {
    const username = 'filip123';
    const password = 'Test123$';

    getUserByUsernameOrEmail.mockReturnValue(mockUser);
    bcryptjs.compare.mockReturnValue(true);

    const user = await loginService(username, password);

    expect({ ...user.user, password: undefined }).toStrictEqual({ ...mockUser.user, password: undefined });
  });

  it('should throw an error that the password is invalid', async () => {
    const username = 'filip123';
    const password = 'Test123$';

    getUserByUsernameOrEmail.mockReturnValue(mockUser);
    bcryptjs.compare.mockReturnValue(false);
    expect(loginService(username, password)).rejects.toThrow('Invalid Password');
  });

  it('should test validation service for an existing user', async () => {
    const user = { username: 'filip123', email: 'filips3855@rocketmail.com', password: 'Test123$' };

    getUserByUsernameOrEmail.mockReturnValue(mockUser);
    expect(signupFieldValidationService(user)).rejects.toThrow('Username already exists');
  });

  it('should test validation service for an existing email', async () => {
    const user = { username: 'filip1233213', email: 'filips3855@rocketmail.com', password: 'Test123$' };
    getUserByUsernameOrEmail.mockReturnValue({ user: { ...mockUser.user, email: 'filips3855@rocketmail.com' } });
    expect(signupFieldValidationService(user)).rejects.toThrow('Email already exists');
  });

  it('should test validation service for an invalid username', async () => {
    const user = { username: 'f1s$', email: 'filips3855@rocketmail.com', password: 'Test123$' };
    getUserByUsernameOrEmail.mockReturnValue([]);
    expect(signupFieldValidationService(user)).rejects.toThrow('Invalid Username');
  });

  it('should test validation service for an invalid email', async () => {
    const user = { username: 'filip1233213', email: 'filipsrocketmail.com', password: 'Test123$' };
    getUserByUsernameOrEmail.mockReturnValue([]);
    expect(signupFieldValidationService(user)).rejects.toThrow('Invalid email');
  });

  it('should test validation service for an invalid password', async () => {
    const user = { username: 'filip1233213', email: 'filips@rocketmail.com', password: 'test123$' };
    getUserByUsernameOrEmail.mockReturnValue([]);
    expect(signupFieldValidationService(user)).rejects.toThrow(
      'Invalid Password! Please insure there is at least one digit, one capital letter and one sign',
    );
  });

  it('should pass validation service', async () => {
    const user = { username: 'filip1233213', email: 'filips@rocketmail.com', password: 'Test123$' };
    getUserByUsernameOrEmail.mockReturnValue([]);
    expect(signupFieldValidationService(user)).resolves.toBeDefined();
  });

  it('should send email verification', async () => {
    const emailInstance = new Email({
      email: 'test@example.com',
      username: 'testuser',
      ID: 123,
      email_verification_token: 1235476,
    });

    emailInstance.sendEmailVerification = jest.fn().mockResolvedValueOnce({
      message: 'Mock email sent successfully!',
      statusCode: 200,
    });

    const result = await emailInstance.sendEmailVerification();

    expect(result).toEqual({
      message: 'Mock email sent successfully!',
      statusCode: 200,
    });

    expect(emailInstance.sendEmailVerification).toHaveBeenCalled();
  });

  it('should signup a user', async () => {
    getUserByUsernameOrEmail.mockReturnValueOnce([]);
    signupFieldValidationService = jest.fn();
    signupFieldValidationService.mockReturnValue({ message: 'Valid parameters!', statusCode: 200 });

    const emailInstance = new Email({
      email: 'test@example.com',
      username: 'testuser',
      ID: 123,
      email_verification_token: 1235476,
    });

    emailInstance.sendEmailVerification = jest.fn().mockResolvedValueOnce({
      message: 'Mock email sent successfully!',
      statusCode: 200,
    });

    createUser.mockReturnValue({ user: { ...mockUser.user, password: undefined }, statusCode: 200 });

    const user = await signupService({ username: 'filip1233213', email: 'test@rocketmail.com', password: 'Test123$' });

    expect({ ...user.user, password: undefined }).toStrictEqual({ ...mockUser.user, password: undefined });
  });

  it('should send the forgot password email', async () => {
    getUserByUsernameOrEmail.mockReturnValue({ user: { ...mockUser.user } });

    const emailInstance = new Email({
      email: 'test@example.com',
      username: 'testuser',
      ID: 123,
      email_verification_token: 1235476,
    });

    emailInstance.sendEmailRetrievingPassword = jest.fn().mockResolvedValueOnce({
      message: 'Mock email sent successfully!',
      statusCode: 200,
    });
    const { user } = await forgotPasswordService('filip123');

    expect(user).toStrictEqual(mockUser.user);
  });

  it('should throw an error that the user is already verified', async () => {
    getUserById.mockReturnValue({ user: { ...mockUser.user, verified: 1 } });
    expect(checkVerificationToken(123456)).rejects.toThrow('User is already verified');
  });

  it('should throw an error that the user token expired', async () => {
    getUserById.mockReturnValue({ user: { ...mockUser.user, verified: 0 } });
    expect(checkVerificationToken(123456)).rejects.toThrow('Email verification token expired!');
  });

  it('should throw an error that the token is invalid', async () => {
    getUserById.mockReturnValue({ user: { ...mockUser.user, verified: 0, time_to_varify: new Date() + 100000, email_verification_token: 1 } });
    expect(checkVerificationToken(123456)).rejects.toThrow('Invalid email verification token!');
  });

  it('should verify the user', async () => {
    checkVerificationToken = jest.fn();

    getUserById.mockReturnValue({
      user: { ...mockUser.user, verified: 0, time_to_varify: new Date() + 100000, email_verification_token: 225946481 },
    });
    checkVerificationToken.mockReturnValue({
      user: { ...mockUser.user, verified: 0, time_to_varify: new Date() + 100000, email_verification_token: 225946481 },
      statusCode: 200,
    });
    updateUserVerification.mockReturnValue({ user: { ...mockUser.user, verified: 1 }, statusCode: 200 });
    const { user } = await verifyUserService(123456, 225946481);
    expect(user).toStrictEqual({ ...mockUser.user, verified: 0, time_to_varify: new Date() + 100000 });
  });

  it('should update user password', async () => {
    updateUserPassword.mockReturnValue({ new_value: 'Test123$' });
    const { new_value } = await updateUserPassword(2, 'Test123$');
    expect(new_value).toBeDefined();
  });
});
