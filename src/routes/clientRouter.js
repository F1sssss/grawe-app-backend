const express = require('express');
const clientController = require('../controllers/clientController');
const policyController = require('../controllers/policyController');

const router = express.Router();

//router.use(authController.protect);

router.get('/:id/history', clientController.getClientHistory);
router.get('/:id/info', clientController.getClientInfo);

router.get('/:id/history/xls/download', clientController.getClientHistoryExcelDownload);
router.get('/:id/history/pdf/download', clientController.getClientHistoryPDFDownload);

router.get('/:id/analyticalInfo', clientController.getClientAnalyticalInfo);
router.get('/:id/analytics/all', clientController.getAllClientAnalytics);

module.exports = router;
