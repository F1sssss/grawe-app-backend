const express = require('express');
const authController = require('../controllers/authController');

const router = express.Router();

router.post('/login', authController.login);
router.get('/logout', authController.logout);
router.post('/signup', authController.signUp);
router.get('/:id/ForgotPassword', authController.forgotPassword);
router.get('/signup/:id/verify/:token', authController.emailVerification);

// Protect all routes after this middleware
router.use(authController.protect);

module.exports = router;
