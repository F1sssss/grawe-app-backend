const express = require('express');

const dashboardController = require('../controllers/dashboardController');

const router = express.Router();

router.route('/:id/guest_token').get(dashboardController.getDashboard);

module.exports = router;
