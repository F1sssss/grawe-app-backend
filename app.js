// Descripton: This file is the main file of the application. It contains all the middlewares and the global middlewares. It also contains security middlewares like CORS, helmet, cookie-parser, xss-clean, compression.

const express = require('express');
const cors = require('cors');
const helmet = require('helmet');
const cookieParser = require('cookie-parser');
const xss = require('xss-clean');
const compression = require('compression');
const morgan = require('morgan');

const errorHandler = require('./src/controllers/errorController');
const logger = require('./src/logging/winstonSetup');

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

app.use(
  morgan(
    function (tokens, req, res) {
      return JSON.stringify({
        method: tokens.method(req, res),
        url: tokens.url(req, res),
        status: Number.parseFloat(tokens.status(req, res)),
        content_length: tokens.res(req, res, 'content-length'),
        response_time: Number.parseFloat(tokens['response-time'](req, res)),
      });
    },
    {
      stream: {
        write: (message) => {
          const data = JSON.parse(message);
          logger.http('Express request', data);
        },
      },
    },
  ),
);

app.enable('trust proxy');

//Global Middlewares

//Implement CORS
app.use(cors());
app.options('*', cors());

//Set security HTTP headers
app.use(helmet());

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

//Error handling middleware
app.use(errorHandler);

module.exports = app;
