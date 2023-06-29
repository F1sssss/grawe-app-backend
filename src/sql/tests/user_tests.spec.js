const DBConnection = require('../DBConnection');
const UserQueries = require('../Queries/UserQueries');

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

describe('User queries tests', () => {
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

  it('should get user by id', async () => {
    const { user } = await UserQueries.getUserById(1);
    expect(user).toHaveProperty('ID');
  });

  it('should throw an error when trying to create a user without all parameters', async () => {
    try {
      const { user } = await UserQueries.createUser({ username: 'Test' });
    } catch (error) {
      expect(error.statusMessage).toBe('error-missing-fields');
    }
  });

  it('should thow an error when trying to get a user by id that does not exist', async () => {
    try {
      await UserQueries.getUserById(10000);
    } catch (error) {
      expect(error.statusMessage).toBe('error-user-not-found');
    }
  });

  it('should thow an error when trying to get a user by that name does not exist', async () => {
    try {
      await UserQueries.getUserByUsername('ajkldhghbsjlhd');
    } catch (error) {
      expect(error.statusMessage).toBe('error-user-not-found');
    }
  });

  it('should thow an error when trying to get a user by that email does not exist', async () => {
    try {
      await UserQueries.getUserByEmail('testFailMail@fail.com');
    } catch (error) {
      expect(error.statusMessage).toBe('error-user-not-found');
    }
  });

  it('should get user by username', async () => {
    const { user } = await UserQueries.getUserByUsername('filip1232133');
    expect(user).toHaveProperty('ID');
  });

  it('should get user by email', async () => {
    const { user } = await UserQueries.getUserByEmail('filips4214@rocketmail.com');
    expect(user).toHaveProperty('ID');
  });

  it('should get user by username or email for login', async () => {
    const { user } = await UserQueries.getUserByUsernameOrEmail('filip', '', 'login');
    expect(user).toHaveProperty('ID');
  });

  it('should not return an error when trying to get a user by username or email for signup', async () => {
    const { user } = await UserQueries.getUserByUsernameOrEmail('filip6146414', '', 'signup');
    expect(user).toEqual(undefined);
  });

  it('should create a user', async () => {
    createdUser = await UserQueries.createUser(userToCreate);
    expect(createdUser).toHaveProperty('user');
  });

  it('should update the verified field', async () => {
    const {
      user: { ID },
    } = createdUser;
    const { newValue } = await UserQueries.updateUserField(ID, 'verified', 1);

    expect(newValue).toEqual(1);
  });

  it('should update the user name', async () => {
    const {
      user: { ID },
    } = createdUser;

    const { newValue } = await UserQueries.updateUserField(ID, 'username', 'TestName');

    expect(newValue).toEqual('TestName');
  });

  it('should delete the user', async () => {
    const {
      user: { ID },
    } = createdUser;
    const { message } = await UserQueries.deleteUser(ID);
    try {
      const { user } = await UserQueries.getUserById(ID);
    } catch (error) {
      expect(error.statusMessage).toBe('error-user-not-found');
    }
  });

  it('should close the connection', async () => {
    const consoleSpy = jest.spyOn(console, 'log');
    await connection.close();
    expect(consoleSpy).toHaveBeenCalledWith('🔒 Connection to MSSQL database closed');
    consoleSpy.mockRestore();
  });
});
