// Description: Controller for user authentication
const cookie = require('cookie-parser');
const loginService = require('../services/userService');

const login = async (req, res, next) => {
  const username = req.body.username;
  const password = req.body.password;

  try {
    const { token, user, statusCode } = await loginService(username, password);
    if (statusCode !== 200) {
      res.status(401).send({
        error: 'Login failed! Check authentication credentials'
      });
      next();
    } else {
      res.cookie('token', token, {
        httpOnly: true,
        secure: req.secure || req.headers['x-forwarded-proto'] === 'https'
      });
      res.status(200).send({
        message: 'Login successful!',
        token: token,
        user: user
      });
    }
  } catch (err) {
    console.error('Error during user login:', err);
    console.log(err);
    res.status(500).send({
      message: 'Error during user login'
    });
    next();
  }
};

module.exports = { login };
