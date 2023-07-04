const express = require('express');
const employeeErrorController = require('../controllers/employeeErrorController');
const authController = require('../controllers/authController');

const router = express.Router();

//router.use(authController.protect);

router.get('/', employeeErrorController.getAllEmployeeErrors);
router.get('/exceptions', employeeErrorController.getAllExceptions);
router.post('/exceptions', employeeErrorController.addErrorException);
router.delete('/exceptions', employeeErrorController.deleteErrorException);
router.patch('/exceptions', employeeErrorController.updateErrorException);

module.exports = router;
