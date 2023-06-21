const express = require('express');
const authController = require('../controllers/authController');
const reportsController = require('../controllers/reportsController');

const router = express.Router();

//router.use(authController.protect);

router.get('/param/', reportsController.getParamValues);
router.get('/searchProcedure/', reportsController.searchProcedure);
router.get('/generate/:id/', reportsController.generateReport);
router.get('/:id/', reportsController.getReportById);
router.get('/', reportsController.getReports);
router.post('/createReport', reportsController.createReport);

module.exports = router;
