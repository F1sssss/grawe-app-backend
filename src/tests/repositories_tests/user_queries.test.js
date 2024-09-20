const DBConnection = require('../../sql/DBConnection');
const UserQueries = require('../../sql/Queries/UserQueries');
const { beforeEach } = require('node:test');

sql = {
  server: '192.168.1.217',
  database: 'GRAWE_WEBAPP_TEST',
  user: 'sa',
  encrypt: false,
  password: 'Grawe123$',
  pool: {
    max: 20,
    min: 0,
    idleTimeoutMillis: 300000,
  },
};

describe('User queries tests', () => {
  let user_id;
  let createdUser;

  const userToCreate = {
    username: `filip4321`,
    password: `Test4321`,
    name: 'Filip',
    last_name: 'Stankovic',
    email: `filips4321@rocketmail.com`,
    date_of_birth: '11.01.1999',
  };

  beforeAll(() => {
    connection = new DBConnection(sql);
    jest.setTimeout(3000000);
  });

  afterAll(async () => {
    await connection.close();
  });

  beforeEach(() => {
    jest.setTimeout(3000000);
  });

  it('should connect to the test database', async () => {
    const consoleSpy = jest.spyOn(console, 'log');
    await connection.connect();
    expect(consoleSpy).toHaveBeenCalledWith('🔒 Connected to MSSQL database');
    consoleSpy.mockRestore();
  });

  it('should throw an error when trying to create a user without all parameters', async () => {
    await expect(UserQueries.createUser({ username: 'Test' })).rejects.toThrow();
    await expect(UserQueries.createUser({ password: 'Test' })).rejects.toThrow();
    await expect(UserQueries.createUser({ name: 'Test' })).rejects.toThrow();
    await expect(UserQueries.createUser({ last_name: 'Test' })).rejects.toThrow();
    await expect(UserQueries.createUser({ email: 'Test' })).rejects.toThrow();
  });

  it('should create a user', async () => {
    createdUser = await UserQueries.createUser(userToCreate);
    expect(createdUser).toMatchObject({
      user: {
        username: userToCreate.username,
        name: userToCreate.name,
        last_Name: userToCreate.last_name,
        email: userToCreate.email,
        date_of_birth: userToCreate.date_of_birth,
      },
    });

    user_id = createdUser.user.ID;
  });

  it('should throw an error when trying to create a user which already exists', async () => {
    await expect(UserQueries.createUser(userToCreate)).rejects.toThrow();
  });

  it('should get user by id', async () => {
    const { user } = await UserQueries.getUserById(user_id);
    expect(user).toMatchObject({
      username: userToCreate.username,
      name: userToCreate.name,
      last_Name: userToCreate.last_name,
      email: userToCreate.email,
      date_of_birth: userToCreate.date_of_birth,
    });
  });

  it('should return an empty object when trying to get by username that doesnt exist', async () => {
    const { user } = await UserQueries.getUserByUsername('testFailName');
    expect(user).toStrictEqual({});
  });

  it('should return an empty object when trying to get by username that sint verified', async () => {
    const { user } = await UserQueries.getUserByUsername(userToCreate.username);
    expect(user).toStrictEqual({});
  });

  it('should return an empty object when trying to get a user by that email does not exist', async () => {
    const { user } = await UserQueries.getUserByEmail('testFailMail@fail.com');
    expect(user).toStrictEqual({});
  });

  it('should return an empty object when trying to get a user by that email that isnt verified', async () => {
    const { user } = await UserQueries.getUserByEmail(userToCreate.email);
    expect(user).toStrictEqual({});
  });

  it('should throw an error that a user is not verified', async () => {
    await expect(UserQueries.getUserByUsernameOrEmail(createdUser.user.username, '', 'login')).rejects.toThrow();
  });

  it('should throw an error that a user doesnt exits', async () => {
    await expect(UserQueries.getUserByUsernameOrEmail('testFailName', 'testFailName', 'login')).rejects.toThrow();
  });

  it('should verify an user', async () => {
    const { newValue } = await UserQueries.updateUserVerification(user_id, 1);
    expect(newValue).toEqual(1);
  });

  it('should get user by username', async () => {
    const { user } = await UserQueries.getUserByUsername(createdUser.user.username);
    expect(user).toMatchObject({
      username: userToCreate.username,
      name: userToCreate.name,
      last_Name: userToCreate.last_name,
      email: userToCreate.email,
      date_of_birth: userToCreate.date_of_birth,
    });
  });

  it('should get user by email', async () => {
    const { user } = await UserQueries.getUserByEmail(createdUser.user.email);
    expect(user).toMatchObject({
      username: userToCreate.username,
      name: userToCreate.name,
      last_Name: userToCreate.last_name,
      email: userToCreate.email,
      date_of_birth: userToCreate.date_of_birth,
    });
  });

  it('should get user by username or email for login', async () => {
    const { user } = await UserQueries.getUserByUsernameOrEmail(createdUser.user.username, '', 'login');
    expect(user).toMatchObject({
      username: userToCreate.username,
      name: userToCreate.name,
      last_Name: userToCreate.last_name,
      email: userToCreate.email,
      date_of_birth: userToCreate.date_of_birth,
    });
  });

  it('should get user by username or email for login', async () => {
    const { user } = await UserQueries.getUserByUsernameOrEmail(createdUser.user.email, createdUser.user.email, 'login');
    expect(user).toMatchObject({
      username: userToCreate.username,
      name: userToCreate.name,
      last_Name: userToCreate.last_name,
      email: userToCreate.email,
      date_of_birth: userToCreate.date_of_birth,
    });
  });

  it('should throw an error when trying to get a user by username or email for login that doesnt exist', async () => {
    await expect(UserQueries.getUserByUsernameOrEmail('filip6146414', '', 'login')).rejects.toThrow();
  });

  it('should return an empty array when trying to get a user by username or email for signup', async () => {
    const { user } = await UserQueries.getUserByUsernameOrEmail('filip6146414', '', 'signup');
    expect(user).toStrictEqual({});
  });

  it('should throw a error that user doesnt exist', async () => {
    await expect(UserQueries.updateUserField(123456, 'username', 'Test')).rejects.toThrow();
  });

  it('should throw a error that that field doesnt exist', async () => {
    await expect(UserQueries.updateUserField(123456, 'test_field', 'Test')).rejects.toThrow();
  });

  it('should update the user name', async () => {
    const { newValue } = await UserQueries.updateUserField(user_id, 'username', 'TestName');

    expect(newValue).toEqual('TestName');
  });

  it('should update the password', async () => {
    const { newValue } = await UserQueries.updateUserPassword(user_id, 'TestPass123$');
    expect(newValue).toBe(undefined);
  });

  it('should update all info', async () => {
    const updateUser = {
      username: `filipUpdated`,
      password: `TestUpdated123$`,
      name: 'FilipUpdated',
      last_Name: 'StankovicUpdated',
      email: 'testemail@gmail.com',
    };

    const { updatedFields } = await UserQueries.updateUser(createdUser.user, updateUser);

    expect(updateUser).toMatchObject({
      username: updatedFields.username,
      name: updatedFields.name,
      last_Name: updatedFields.last_Name,
      email: updatedFields.email,
    });

    expect(updatedFields.password).toBeUndefined();
  });

  it('should get an array of users', async () => {
    const { users } = await UserQueries.getAllUsers();
    expect(Array.isArray(users)).toBe(true);
  });

  it('should get empty array for user', async () => {
    const { user } = await UserQueries.getMyPermissions(user_id);
    expect(user).toStrictEqual([]);
  });

  it('should delete the user', async () => {
    const { message } = await UserQueries.deleteUser(user_id);
    expect(message).toEqual('User Deleted successfully!');
  });

  it('should create an AD user', async () => {
    const adUser = {
      sAMAccountName: 'testAdUser',
      givenName: 'TestAdName',
      sn: 'TestAdLastName',
      mail: 'test@grawe.at.me',
    };

    const { user } = await UserQueries.createADUser(adUser);

    expect(user).toMatchObject({
      username: adUser.sAMAccountName,
      name: adUser.givenName,
      last_Name: adUser.sn,
      email: adUser.mail,
    });
  });

  it('should throw an error when trying to create an AD user without all parameters', async () => {
    await expect(UserQueries.createADUser({ sAMAccountName: 'Test' })).rejects.toThrow();
    await expect(UserQueries.createADUser({ givenName: 'Test' })).rejects.toThrow();
    await expect(UserQueries.createADUser({ sn: 'Test' })).rejects.toThrow();
    await expect(UserQueries.createADUser({ mail: 'Test' })).rejects.toThrow();
  });

  it('should delete the AD user that was made in the previous test', async () => {
    const { user } = await UserQueries.getUserByUsername('testAdUser');
    const { message } = await UserQueries.deleteUser(user.ID);
    expect(message).toEqual('User Deleted successfully!');
  });

  it('should close the connection', async () => {
    const consoleSpy = jest.spyOn(console, 'log');
    await connection.close();
    expect(consoleSpy).toHaveBeenCalledWith('🔒 Connection to MSSQL database closed');
    consoleSpy.mockRestore();
  });
});
