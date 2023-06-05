// Description: Controller for user authentication
const authServices = require('../services/authServices');

const login = async (req, res, next) => {
  const username = req.body.username;
  const password = req.body.password;

  try {
    await authServices
      .loginService(username, password)
      .then((result) => {
        res.cookie('token', result.token, {
          httpOnly: true,
          secure: req.secure || req.headers['x-forwarded-proto'] === 'https'
        });
        res.status(200).send({
          message: 'Login successful!',
          token: result.token,
          user: result.user
        });
      })
      .catch((err) => {
        console.error('Error during user login:', err);
        res.status(401).send({
          error: 'Login failed! Check authentication credentials'
        });
      });
  } catch (err) {
    console.error('Error during user login:', err);
    console.log(err);
    res.status(500).send({
      message: 'Error during user login'
    });
    next();
  }
};

const logout = async (req, res, next) => {
  res.cookie('jwt', 'loggedout', {
    httpOnly: true,
    expires: new Date(Date.now() + 10 * 1000)
  });
  res.status(200).json({ status: 'success' });
  next();
};

const signUp = async (req, res, next) => {
  const username = req.body.username;
  const password = req.body.password;
  const name = req.body.name;
  const last_name = req.body.last_name;
  const email = req.body.email;
  const DOB = req.body.Date_of_birth;

  await authServices
    .signupService(username, password, name, last_name, email, DOB)
    .then((result) => {
      res.cookie('token', result.token, {
        httpOnly: true,
        secure: req.secure || req.headers['x-forwarded-proto'] === 'https'
      });
      res.status(200).send({
        message: 'Signup successful!',
        token: result.token,
        user: result.user
      });
      next();
    })
    .catch((err) => {
      console.error('Error during user signup:', err);
      console.log(err);
      res
        .status(401)
        .send({ error: 'Signup failed! Check authentication credentials' });
      next();
    });
};

module.exports = { login, logout, signUp };
