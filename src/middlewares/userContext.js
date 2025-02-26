const { AsyncLocalStorage } = require('async_hooks');
const logger = require('../logging/winstonSetup');

const userContextStorage = new AsyncLocalStorage();

const setupUserContext = (req, res, next) => {
  const userContext = req.user
    ? {
        userId: req.user.ID,
        username: req.user.username,
      }
    : null;

  userContextStorage.run(userContext, () => {
    next();
  });
};

const getUserContext = () => {
  return userContextStorage.getStore();
};

module.exports = {
  setupUserContext,
  getUserContext,
};
