const express = require('express');
const clientController = require('../controllers/clientController');

const router = express.Router();

//router.use(authController.protect);

router.get('/:id/history', clientController.getClientHistory);
router.get('/:id/info', clientController.getClientInfo);
router.get('/:id/analyticalInfo', clientController.getClientAnalyticalInfo);

module.exports = router;
