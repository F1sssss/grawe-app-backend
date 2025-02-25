const express = require('express');
const clientController = require('../controllers/clientController');
const accessControlMiddleware = require('../middlewares/accessControl');
const authController = require('../controllers/authController');
const setupUserContext = require('../middlewares/userContext');

const router = express.Router();

router.use(authController.protect);
router.use(setupUserContext.setupUserContext);

router.get('/:id/history', clientController.getClientHistory);
router.get('/:id/info', clientController.getClientInfo);

router.get('/:id/history/xls/download', clientController.getClientHistoryExcelDownload);
router.get('/:id/history/pdf/download', clientController.getClientHistoryPDFDownload);
router.get('/:id/finhistory/pdf/download', clientController.getClientFinancialHistoryPDFDownload);

router.get('/:id/analytics', clientController.getClientAnalyticalInfo);
router.get('/policy/:id', clientController.getClientPolicyAnalyticalInfo);
router.get('/:id/analytics/all', clientController.getAllClientAnalytics);

//This is just for testing, remove later
router.get('/:id/analytics/allInfo', clientController.getAllClientInfo);

module.exports = router;
