const express = require('express');
const authController = require('../controllers/authController');
const reportsController = require('../controllers/reportsController');

const router = express.Router();

//router.use(authController.protect);

router.get('/getReports', reportsController.getReports);
router.get('/:id', reportsController.getReportById);
router.get('/:id/generate', reportsController.generateReport);

module.exports = router;
