const jwt = require('jsonwebtoken');
const AppError = require('../../utils/AppError');
const SQLQueries = require('../../sql/Queries/userQueries');
const {
  getMeService,
  updateMeService,
  deleteMeService,
  getAllUsersService,
  getUserService,
  getMyPermissionsService,
} = require('../../services/userService');

jest.mock('jsonwebtoken');
jest.mock('../../utils/AppError');
jest.mock('../../sql/DBconfig');
jest.mock('../../sql/Queries/userQueries');

describe('User Service', () => {
  afterEach(() => {
    jest.clearAllMocks();
  });

  describe('getMeService', () => {
    it('should return token and user when valid token is provided in headers', async () => {
      const mockReq = {
        headers: { authorization: 'Bearer validToken' },
      };
      const mockUser = { id: 1, username: 'testuser' };
      jwt.verify.mockImplementation((token, secret, callback) => callback(null, { username: 'testuser' }));
      SQLQueries.getUserByUsernameOrEmail.mockResolvedValue({ user: mockUser });

      const result = await getMeService(mockReq);

      expect(result).toEqual({ token: 'validToken', user: mockUser });
    });

    it('should throw an error when user has no permissions', async () => {
      const mockReq = {
        headers: { authorization: 'Bearer validToken' },
        cookies: {},
      };
      const mockUser = { ID: 1, username: 'testuser' };
      jwt.verify.mockImplementation((token, secret, callback) => callback(null, { username: 'testuser' }));
      SQLQueries.getUserByUsernameOrEmail.mockResolvedValue({ user: mockUser });
      SQLQueries.getMyPermissions.mockResolvedValue({ user: [] });

      try {
        await getMyPermissionsService(mockReq);
        fail('Expected getMyPermissionsService to throw an error');
      } catch (error) {
        expect(error).toBeInstanceOf(AppError);
      }
    });
  });

  describe('updateMeService', () => {
    it('should update user and return updated fields', async () => {
      const mockData = {
        user: { id: 1 },
        body: { name: 'New Name' },
      };
      const mockUpdatedFields = { name: 'New Name' };
      SQLQueries.updateUser.mockResolvedValue({ updatedFields: mockUpdatedFields });

      const result = await updateMeService(mockData);

      expect(result).toEqual({ updatedFields: mockUpdatedFields });
    });
  });

  describe('deleteMeService', () => {
    it('should delete user and return success message', async () => {
      const mockData = { user: { ID: 1 } };
      const mockMessage = 'User deleted successfully';
      SQLQueries.deleteUser.mockResolvedValue({ message: mockMessage });

      const result = await deleteMeService(mockData);

      expect(result).toEqual({ message: mockMessage });
    });
  });

  describe('getAllUsersService', () => {
    it('should return all users', async () => {
      const mockUsers = [
        { id: 1, username: 'user1' },
        { id: 2, username: 'user2' },
      ];
      SQLQueries.getAllUsers.mockResolvedValue({ users: mockUsers });

      const result = await getAllUsersService();

      expect(result).toEqual({ users: mockUsers });
    });
  });

  describe('getUserService', () => {
    it('should return a specific user by id', async () => {
      const mockReq = { params: { id: 1 } };
      const mockUser = { id: 1, username: 'testuser' };
      SQLQueries.getUserById.mockResolvedValue({ user: mockUser });

      const result = await getUserService(mockReq);

      expect(result).toEqual({ user: mockUser });
    });
  });
  describe('getMyPermissionsService', () => {
    it('should return user permissions', async () => {
      const mockReq = {
        headers: { authorization: 'Bearer validToken' },
        cookies: {},
      };
      const mockUser = { ID: 1, username: 'testuser' };
      const mockPermissions = [
        { route: '/api/test', method: 'GET', property_path: 'test', read_right: 1, write_right: 0 },
        { route: '/api/test', method: 'POST', property_path: 'test', read_right: 1, write_right: 1 },
      ];
      jwt.verify.mockImplementation((token, secret, callback) => callback(null, { username: 'testuser' }));
      SQLQueries.getUserByUsernameOrEmail.mockResolvedValue({ user: mockUser });
      SQLQueries.getMyPermissions.mockResolvedValue({ user: mockPermissions });

      const result = await getMyPermissionsService(mockReq);

      expect(result).toEqual({
        permissions: [
          {
            route: '/api/test',
            methods: ['GET', 'POST'],
            properties: [
              { property_path: 'test', read_right: 1, write_right: 0 },
              { property_path: 'test', read_right: 1, write_right: 1 },
            ],
          },
        ],
      });
    });

    it('should throw an error when user has no permissions', async () => {
      const mockReq = {
        headers: { authorization: 'Bearer validToken' },
        cookies: {},
      };
      const mockUser = { ID: 1, username: 'testuser' };
      jwt.verify.mockImplementation((token, secret, callback) => callback(null, { username: 'testuser' }));
      SQLQueries.getUserByUsernameOrEmail.mockResolvedValue({ user: mockUser });
      SQLQueries.getMyPermissions.mockResolvedValue({ user: [] });

      try {
        await getMyPermissionsService(mockReq);
      } catch (error) {
        expect(error).toBeInstanceOf(AppError);
      }
    });
  });
});
