const express = require('express');
const authController = require('../controllers/authController');

const router = express.Router();

router.post('/login', authController.login);
router.get('/logout', authController.logout);
router.post('/signup', authController.signUp);
router.post('/signup/verification', authController.emailVerification);
router.post('/forgot-password/', authController.forgotPassword);
router.post('/forgot-password/new-password/', authController.setNewPassword);

router.use(authController.protect);

module.exports = router;
