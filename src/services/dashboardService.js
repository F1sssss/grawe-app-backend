const axios = require('axios');

const getDashboardService = async (id) => {
  const response = await axios.post('http://127.0.0.1:8088/api/v1/security/login', {
    username: 'admin',
    password: 'admin',
    provider: 'db',
  });

  const user_jwt_token = response.data.access_token;

  const {
    data: {
      result: { uuid },
    },
  } = await axios.get(`http://127.0.0.1:8088/api/v1/dashboard/${id}/embedded`, {
    headers: { Authorization: `Bearer ${user_jwt_token}` },
  });

  const GuestToken = await axios.post(
    'http://localhost:8088/api/v1/security/guest_token/',
    {
      resources: [
        {
          id: uuid,
          type: 'dashboard',
        },
      ],
      rls: [],
      user: {
        first_name: 'Test',
        last_name: 'Test',
        username: 'test',
      },
    },
    { headers: { Authorization: `Bearer ${user_jwt_token}` } },
  );

  return { dashboard_uuid: uuid, guest_token: GuestToken.data.token };
};

module.exports = {
  getDashboardService,
};
