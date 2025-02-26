const { AsyncLocalStorage } = require('async_hooks');
const logger = require('../logging/winstonSetup');

const asyncLocalStorage = new AsyncLocalStorage();

const requestContextMiddleware = (req, res, next) => {
  const context = {
    requestId: req.id,
    path: req.path,
    method: req.method,
    userId: req.user ? req.user.ID : null,
    username: req.user ? req.user.username : null,
    timestamp: new Date().toISOString(),
  };

  asyncLocalStorage.run(context, () => {
    logger.debug('Request context created', {
      type: 'context-created',
      requestId: context.requestId,
    });

    next();
  });
};

const getRequestContext = () => {
  return asyncLocalStorage.getStore();
};

const getUserContext = () => {
  const store = asyncLocalStorage.getStore();
  if (!store) return null;

  return {
    userId: store.userId,
    username: store.username,
    requestId: store.requestId,
  };
};

module.exports = {
  requestContextMiddleware,
  getRequestContext,
  getUserContext,
};
