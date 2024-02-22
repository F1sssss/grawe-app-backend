// Descripton: This file is the main file of the application. It contains all the middlewares and the global middlewares. It also contains security middlewares like CORS, helmet, cookie-parser, xss-clean, compression.

const express = require('express');
const cors = require('cors');
const helmet = require('helmet');
const cookieParser = require('cookie-parser');
const xss = require('xss-clean');
const compression = require('compression');

const errorController = require('./src/controllers/errorController');

const userRouter = require('./src/routes/userRouter');
const policyRouter = require('./src/routes/policyRouter');
const reportsRouter = require('./src/routes/reportsRouter');
const clientRouter = require('./src/routes/clientRouter');
const searchRouter = require('./src/routes/searchRouter');
const employeeErrorRouter = require('./src/routes/employeeErrorRouter');
const permissionRouter = require('./src/routes/permissionRouter');

//start express app
const app = express();

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

//test middleware
app.use((req, res, next) => {
  req.requestTime = new Date().toISOString();
  next();
});

//Routes

app.use('/api/v1/users', userRouter);
app.use('/api/v1/policies', policyRouter);
app.use('/api/v1/clients', clientRouter);
app.use('/api/v1/reports', reportsRouter);
app.use('/api/v1/search', searchRouter);
app.use('/api/v1/errors', employeeErrorRouter);
app.use('/api/v1/permissions', permissionRouter);

//Error handling middleware
app.use(errorController);

module.exports = app;
