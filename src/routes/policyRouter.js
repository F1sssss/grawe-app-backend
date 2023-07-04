const express = require('express');
const policyController = require('../controllers/policyController');
const authController = require('../controllers/authController');

const router = express.Router();

//router.use(authController.protect);

router.get('/:id/history', policyController.getPolicyHistory);
router.get('/:id/info', policyController.getPolicyInfo);

router.get('/:id/history/xls/download', policyController.getPolicyHistoryExcelDownload);
router.get('/:id/history/pdf/download', policyController.getPolicyHistoryPDFDownload);

router.get('/:id/analytics/info', policyController.getPolicyAnalyticalInfo);
router.get('/:id/analytics/all', policyController.getAllPolicyAnalytics);
module.exports = router;
