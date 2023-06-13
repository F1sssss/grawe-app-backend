const express = require('express');
const policyController = require('../controllers/policyController');
const authController = require('../controllers/authController');

const router = express.Router();

//router.use(authController.protect);

router.get('/policy-history/', policyController.getPolicyHistory);
router.get(
  '/policy-history/xls/download',
  policyController.getPolicyHistoryExcelDownload
);
router.get('/policy-info/', policyController.getPolicyInfo);
router.get(
  '/policy-history/pdf/download',
  policyController.getPolicyHistoryPDFDownload
);

module.exports = router;
