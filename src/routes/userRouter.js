const express = require('express');
const authController = require('../controllers/authController');
const userController = require('../controllers/userController');

const router = express.Router();

router.get('/', userController.getAllUsers);

router.post('/signup', authController.signUp);
router.post('/login', authController.login);
router.get('/logout', authController.logout);
router.get('/signup/verification', authController.emailVerification);
router.post('/forgot-password/', authController.forgotPassword);
router.post('/forgot-password/new-password/', authController.setNewPassword);

router.use(authController.protect);

router.get('/me', userController.getMe);
router.patch('/me', userController.updateMe);
router.delete('/me', userController.deleteMe);
router.get('/:id', userController.getUser);
router.get('/me/permissions', userController.getMyPermissions);

module.exports = router;
