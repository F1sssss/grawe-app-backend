const express = require('express');
const authController = require('../controllers/authController');
const reportsController = require('../controllers/reportsController');
const cachingService = require('../services/cachingService');
const accessControlMiddleware = require('../middlewares/accessControl');

const router = express.Router();

router.use(authController.protect);

router.get('/param/', reportsController.getParamValues);
router.get('/procedure/', reportsController.searchProcedure);
router.get('/generate/:id/', reportsController.generateReport);
router.get('/:id/', reportsController.getReportById);
router.get('/', accessControlMiddleware, reportsController.getReports);
router.get('/xls/:id/', reportsController.downloadReport);

router.post('/*', cachingService.del);
router.post('/', reportsController.createReport);
router.post('/xls/', reportsController.downloadFilteredReport);

router.patch('/*', cachingService.del);
router.patch('/:id/', reportsController.updateReport);

router.delete('/*', cachingService.del);
router.delete('/:id/', reportsController.deleteReport);

module.exports = router;
