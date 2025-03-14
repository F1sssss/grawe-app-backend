const express = require('express');
const cors = require('cors');
const helmet = require('helmet');
const cookieParser = require('cookie-parser');
const xss = require('xss-clean');
const compression = require('compression');
const config = require('./src/config/config');
const errorHandler = require('./src/controllers/errorController');
const initializeLogging = require('./src/logging');
const { requestContextMiddleware } = require('./src/middlewares/requestContext'); // New import
const requestLogger = require('./src/middlewares/requestLogger'); // New import

// Routes
const userRouter = require('./src/routes/userRouter');
const policyRouter = require('./src/routes/policyRouter');
const reportsRouter = require('./src/routes/reportsRouter');
const clientRouter = require('./src/routes/clientRouter');
const searchRouter = require('./src/routes/searchRouter');
const employeeErrorRouter = require('./src/routes/employeeErrorRouter');
const permissionRouter = require('./src/routes/permissionRouter');
const dashboardRouter = require('./src/routes/dashboardRouter');

//start express app
const app = express();

if (config.isProduction) {
  app.enable('trust proxy');
}

app.use(requestContextMiddleware);
app.use(requestLogger);

const corsOptions = {
  origin: config.isProduction
    ? [config.frontend.url] // Restrict to specific origins in production
    : '*', // Allow all origins in development
  credentials: true,
  methods: 'GET,HEAD,PUT,PATCH,POST,DELETE',
  preflightContinue: false,
  optionsSuccessStatus: 204,
};

//Implement CORS
app.use(cors());
app.options('*', cors());

// Security HTTP headers
// Apply stricter security in production
if (config.isProduction) {
  app.use(
    helmet({
      contentSecurityPolicy: {
        directives: {
          defaultSrc: ["'self'"],
          scriptSrc: ["'self'", "'unsafe-inline'"], // Adjust as needed
          styleSrc: ["'self'", "'unsafe-inline'"],
          imgSrc: ["'self'", 'data:'],
          connectSrc: ["'self'"],
          fontSrc: ["'self'"],
          objectSrc: ["'none'"],
          mediaSrc: ["'self'"],
          frameSrc: ["'self'"],
        },
      },
      referrerPolicy: { policy: 'same-origin' },
      xssFilter: true,
      noSniff: true,
      hsts: {
        maxAge: 15552000, // 180 days
        includeSubDomains: true,
        preload: true,
      },
    }),
  );
} else {
  // Simpler helmet config for development
  app.use(helmet());
}

//Body parser, reading data from body into req.body

//Extending limit of data received
app.use(express.json({ limit: '200mb' }));
app.use(express.urlencoded({ extended: true, limit: '200mb' }));
app.use(cookieParser());

//Data sanitization against XSS
app.use(xss());

//Optimizing the sent data
app.use(compression());

//Routes
app.use(`/api/${process.env.API_VERSION}/users`, userRouter);
app.use(`/api/${process.env.API_VERSION}/policies`, policyRouter);
app.use(`/api/${process.env.API_VERSION}/clients`, clientRouter);
app.use(`/api/${process.env.API_VERSION}/reports`, reportsRouter);
app.use(`/api/${process.env.API_VERSION}/search`, searchRouter);
app.use(`/api/${process.env.API_VERSION}/errors`, employeeErrorRouter);
app.use(`/api/${process.env.API_VERSION}/permissions`, permissionRouter);
app.use(`/api/${process.env.API_VERSION}/dashboard`, dashboardRouter);

app.get(`/api/${process.env.API_VERSION}/health`, (req, res) => {
  res.status(200).json({
    status: 'ok',
    environment: config.env,
    timestamp: new Date().toISOString(),
  });
});

//Error handling middleware
app.use(errorHandler);

module.exports = app;
