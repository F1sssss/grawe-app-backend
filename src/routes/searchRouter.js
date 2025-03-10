const express = require('express');
const authController = require('../controllers/authController');
const searchController = require('../controllers/searchController');
const { setupUserContext } = require('../middlewares/userContext');

const router = express.Router();

router.use(authController.protect);
router.use(setupUserContext);

router.get('/all', searchController.searchAllController);
router.get('/', searchController.globalSearchController);

module.exports = router;
