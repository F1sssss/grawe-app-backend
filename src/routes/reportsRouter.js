const express = require('express');
const authController = require('../controllers/authController');
const reportsController = require('../controllers/reportsController');
const cachingService = require('../services/cachingService');

const router = express.Router();

//router.use(authController.protect);

router.get('/param/', reportsController.getParamValues);
router.get('/procedure/', reportsController.searchProcedure);
router.get('/generate/:id/', reportsController.generateReport);
router.get('/:id/', reportsController.getReportById);
router.get('/', reportsController.getReports);
router.get('/xls/:id/', reportsController.downloadReport);

router.post('/', reportsController.createReport);
router.post('/xls/', reportsController.downloadFilteredReport);
router.post('/*', cachingService.del);

router.patch('/:id/', reportsController.updateReport);
router.patch('/*', cachingService.del);

router.delete('/:id/', reportsController.deleteReport);
router.delete('/*', cachingService.del);

module.exports = router;
