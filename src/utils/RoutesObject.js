module.exports = class RouteObject {
  constructor(routes = []) {
    if (RouteObject._instance) {
      return RouteObject._instance;
    }
    this.routes = routes;
    RouteObject._instance = this;
  }

  getGETRoutes() {
    return this.routes.filter((route) => route.methods.includes('GET'));
  }

  getPATCHRoutes() {
    return this.routes.filter((route) => route.method === 'patch');
  }
};
