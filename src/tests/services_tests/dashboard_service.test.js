const axios = require('axios');
const dashboardService = require('../../services/dashboardService');

jest.mock('axios');

describe('Dashboard Service', () => {
  beforeEach(() => {
    process.env.SUPERSET_URL = 'http://superset-url';
    process.env.SUPERSET_USERNAME = 'test-username';
    process.env.SUPERSET_PASSWORD = 'test-password';
    process.env.USER_FIRST_NAME = 'John';
    process.env.USER_LAST_NAME = 'Doe';
    process.env.USER_USERNAME = 'johndoe';
  });

  afterEach(() => {
    jest.clearAllMocks();
  });

  describe('getDashboardService', () => {
    it('should return dashboard uuid and guest token', async () => {
      const mockLoginResponse = {
        data: {
          access_token: 'mock-jwt-token',
        },
      };

      const mockDashboardResponse = {
        data: {
          result: {
            uuid: 'mock-dashboard-uuid',
          },
        },
      };

      const mockGuestTokenResponse = {
        data: {
          token: 'mock-guest-token',
        },
      };

      axios.post.mockResolvedValueOnce(mockLoginResponse);
      axios.get.mockResolvedValueOnce(mockDashboardResponse);
      axios.post.mockResolvedValueOnce(mockGuestTokenResponse);

      const result = await dashboardService.getDashboardService('dashboard-id');

      expect(axios.post).toHaveBeenCalledWith('http://superset-url/security/login', {
        username: 'test-username',
        password: 'test-password',
        provider: 'db',
      });

      expect(axios.get).toHaveBeenCalledWith('http://superset-url/dashboard/dashboard-id/embedded', {
        headers: { Authorization: 'Bearer mock-jwt-token' },
      });

      expect(axios.post).toHaveBeenCalledWith(
        'http://superset-url/security/guest_token/',
        {
          resources: [
            {
              id: 'mock-dashboard-uuid',
              type: 'dashboard',
            },
          ],
          rls: [],
          user: {
            first_name: 'John',
            last_name: 'Doe',
            username: 'johndoe',
          },
        },
        { headers: { Authorization: 'Bearer mock-jwt-token' } },
      );

      expect(result).toEqual({
        dashboard_uuid: 'mock-dashboard-uuid',
        guest_token: 'mock-guest-token',
      });
    });

    it('should throw an error if any API call fails', async () => {
      axios.post.mockRejectedValueOnce(new Error('API Error'));

      await expect(dashboardService.getDashboardService('dashboard-id')).rejects.toThrow('API Error');
    });
  });
});
