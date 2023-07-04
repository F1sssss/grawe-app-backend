const express = require('express');
const authController = require('../controllers/authController');
const reportsController = require('../controllers/reportsController');

const router = express.Router();

//router.use(authController.protect);

router.get('/param/', reportsController.getParamValues);
router.get('/procedure/', reportsController.searchProcedure);
router.get('/generate/:id/', reportsController.generateReport);
router.get('/:id/', reportsController.getReportById);
router.get('/', reportsController.getReports);
router.post('/', reportsController.createReport);
router.patch('/:id/', reportsController.updateReport);
router.delete('/:id/', reportsController.deleteReport);

module.exports = router;
