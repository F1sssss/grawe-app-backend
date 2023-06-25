const DBConnection = require('../../sql/DBConnection');
const authService = require('../authServices');

sql = {
  server: 'localhost',
  database: 'GRAWE_TEST',
  user: 'sa',
  encrypt: false,
  password: 'Grawe123$',
  pool: {
    max: 20,
    min: 0,
    idleTimeoutMillis: 30000,
  },
};

describe('authentication service', () => {
  const random = Math.floor(Math.random() * 10000);
  let createdUser;

  const userToCreate = {
    username: `filip${random}`,
    password: `Test${random}$`,
    name: 'Filip',
    last_name: 'Stankovic',
    email: `filips${random}@rocketmail.com`,
    date_of_birth: '11.01.1999',
  };

  beforeAll(() => {
    connection = new DBConnection(sql);
  });

  it('should connect to the test database', async () => {
    const consoleSpy = jest.spyOn(console, 'log');
    await connection.connect();
    expect(consoleSpy).toHaveBeenCalledWith('🔒 Connected to MSSQL database');
    consoleSpy.mockRestore();
  });

  it('should create a user', async () => {
    createdUser = await authService.signupService(userToCreate);
    expect(createdUser).toHaveProperty('user');
  });

  it('should verify a user', async () => {
    const {
      user: { ID, email_verification_token },
    } = createdUser;
    const user = await authService.verifyUserService(ID, email_verification_token);
    expect(user).toHaveProperty('user');
  });

  it('should login a user', async () => {
    const user = await authService.loginService(userToCreate.username, userToCreate.password);
    expect(user).toHaveProperty('user');
  });

  it('should change a password', async () => {
    const {
      user: { ID },
    } = createdUser;
    const user = await authService.setNewPasswordService('Test123$', ID);
    expect(user).toHaveProperty('user');
  });

  it('should throw a there is that user error', async () => {
    try {
      await authService.signupService(userToCreate);
    } catch (error) {
      expect(error.statusMessage).toBe('error-username-exists');
    }
  });

  it('should throw a there is that email error', async () => {
    try {
      userToCreate.username = `filip${random + 1}`;
      await authService.signupService(userToCreate);
    } catch (error) {
      expect(error.statusMessage).toBe('error-email-exists');
    }
  });

  it('should throw a invalid username error', async () => {
    try {
      userToCreate.username = `fis$`;
      userToCreate.email = `filips${random + 1}@rocektmail.com`;
      await authService.signupService(userToCreate);
    } catch (error) {
      expect(error.statusMessage).toBe('error-invalid-username');
    }
  });

  it('should throw a invalid email error', async () => {
    try {
      userToCreate.username = `filip${random + 2}`;
      userToCreate.email = `kjabhnsdkjasnbd@dasda`;
      await authService.signupService(userToCreate);
    } catch (error) {
      expect(error.statusMessage).toBe('error-invalid-email');
    }
  });

  it('should throw a invalid password error', async () => {
    try {
      userToCreate.email = `filips385@rocketmail.com`;
      userToCreate.password = `Test`;
      await authService.signupService(userToCreate);
    } catch (error) {
      expect(error.statusMessage).toBe('error-invalid-password');
    }
  });
});
