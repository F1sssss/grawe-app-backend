const express = require('express');
const policyController = require('../controllers/policyController');
const authController = require('../controllers/authController');

const router = express.Router();

//router.use(authController.protect);

router.get('/:id/history', policyController.getPolicyHistory);
router.get(
  '/policy-history/xls/download',
  policyController.getPolicyHistoryExcelDownload
);
router.get('/:id/info', policyController.getPolicyInfo);
router.get(
  '/policy-history/pdf/download',
  policyController.getPolicyHistoryPDFDownload
);

module.exports = router;
