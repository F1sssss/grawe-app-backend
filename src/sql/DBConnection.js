const { ConnectionPool } = require('mssql');
const AppError = require('../utils/AppError');
const logger = require('../logging/winstonSetup');
const loadSqlQueries = require('./sql_queries/loadSQLQueries');
const { getUserContext } = require('../middlewares/userContext');

module.exports = class DBConnection {
  constructor(config) {
    if (DBConnection._instance) {
      this.pool = new ConnectionPool(config);
      return DBConnection._instance;
    }
    this.pool = new ConnectionPool(config);
    DBConnection._instance = this;
  }

  async connect() {
    try {
      logger.info('Connecting to MSSQL database...');
      const startTime = Date.now();
      await this.pool.connect();
      const connectTime = Date.now() - startTime;

      logger.info(`Connected to MSSQL database in ${connectTime}ms`, {
        type: 'database-connection',
        status: 'success',
        duration: connectTime,
        connectionId: this.pool.pool.id,
      });
    } catch (err) {
      logger.error(`Failed to connect to MSSQL database: ${err.message}`, {
        type: 'database-connection',
        status: 'error',
        error: err,
      });
      throw new AppError(`Error connecting to MSSQL database: ${err.message}`, 500, 'error-connecting-to-db');
    }
  }

  async close() {
    try {
      logger.info('Closing connection to MSSQL database...');
      const startTime = Date.now();
      await this.pool.close();
      const closeTime = Date.now() - startTime;

      logger.info(`Closed connection to MSSQL database in ${closeTime}ms`, {
        type: 'database-connection',
        status: 'closed',
        duration: closeTime,
      });
    } catch (err) {
      logger.error(`Error closing database connection: ${err.message}`, {
        type: 'database-connection',
        status: 'error',
        error: err,
      });
      throw new AppError(`Error closing database connection: ${err.message}`, 500, 'error-closing-db-connection');
    }
  }

  async executeQuery(query, params = [], multipleResultSets = false) {
    const query_name = query;
    const startTime = Date.now();

    const userContext = getUserContext();
    const requestId = userContext && userContext.requestId ? userContext.requestId : 'background';

    try {
      const request = await this.pool.request();
      let queryText = query;

      // Load SQL from file if needed
      if (query.includes('.sql')) {
        queryText = await loadSqlQueries(query);
      }

      // Add current user as parameter if available
      if (userContext && userContext.userId) {
        request.input('currentUserId', userContext.userId);
      }

      // Add all parameters to the request
      params.forEach((param) => {
        request.input(param.name, param.type, param.value);
      });

      request.multiple = multipleResultSets;

      // Log query execution start
      logger.debug(`Executing query: ${query_name}`, {
        type: 'database-query-start',
        query: query_name,
        requestId,
        paramCount: params.length,
      });

      const result = await request.query(queryText);
      const duration = Date.now() - startTime;

      // Process results
      const processedResult = multipleResultSets === false ? result.recordset : result.recordsets;
      const finalResult = processedResult?.length === 1 ? processedResult[0] : processedResult?.length === 0 ? undefined : processedResult;

      // Log successful query
      logger.logQuery(
        query_name,
        params.map((p) => ({ name: p.name, type: p.type?.toString() })),
        duration,
        'success',
      );

      return finalResult;
    } catch (err) {
      const duration = Date.now() - startTime;

      // Log failed query with detailed error
      logger.error(`Query execution error: ${err.message}`, {
        type: 'database-query-error',
        query: query_name,
        duration,
        requestId,
        error: err,
        params: params.map((p) => ({ name: p.name, type: p.type?.toString() })),
      });

      throw new AppError(`Error executing query: ${err.message}`, 500, 'error-executing-query');
    }
  }

  async executeStoredProcedure(storedProcedure, params = []) {
    const startTime = Date.now();

    const userContext = getUserContext();
    const requestId = userContext && userContext.requestId ? userContext.requestId : 'background';

    try {
      const request = await this.pool.request();

      // Add current user as parameter if available
      if (userContext && userContext.userId) {
        request.input('currentUserId', userContext.userId);
      }

      // Add all parameters to the request
      params.forEach((param) => {
        request.input(param.name, param.type, param.value);
      });

      // Log stored procedure execution start
      logger.debug(`Executing stored procedure: ${storedProcedure}`, {
        type: 'database-procedure-start',
        procedure: storedProcedure,
        requestId,
        paramCount: params.length,
      });

      const result = await request.execute(storedProcedure);
      const duration = Date.now() - startTime;

      // Log successful stored procedure execution
      logger.debug(`Stored procedure executed: ${storedProcedure} in ${duration}ms`, {
        type: 'database-procedure',
        procedure: storedProcedure,
        duration,
        status: 'success',
        requestId,
      });

      return result.recordsets[0];
    } catch (err) {
      const duration = Date.now() - startTime;

      // Log failed stored procedure with detailed error
      logger.error(`Stored procedure execution error: ${err.message}`, {
        type: 'database-procedure-error',
        procedure: storedProcedure,
        duration,
        requestId,
        error: err,
        params: params.map((p) => ({ name: p.name, type: p.type?.toString() })),
      });

      throw new AppError(`Error executing stored procedure ${storedProcedure}: ${err.message}`, 500, 'error-executing-query');
    }
  }
};
