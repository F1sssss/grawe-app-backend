// Descripton: This file is the main file of the application. It contains all the middlewares and the global middlewares. It also contains security middlewares like CORS, helmet, cookie-parser, xss-clean, compression.

const express = require('express');
const cors = require('cors');
const helmet = require('helmet');
const cookieParser = require('cookie-parser');
const xss = require('xss-clean');
const compression = require('compression');

const userRouter = require('./src/routes/userRouter');

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

app.use(express.json());
app.use(express.urlencoded({ extended: true }));
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

app.use('/api/v1/users', userRouter);

module.exports = app;
