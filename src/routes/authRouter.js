const accessControlController = require('../controllers/accessControlController');
const router = require('express').Router();

router.get('/groups', accessControlController.getGroups);
router.get('/groups/:id', accessControlController.getGroup);
router.post('/groups', accessControlController.createGroup);
router.put('/groups/:id', accessControlController.updateGroup);

router.get('/permissions', accessControlController.getPermissions);
router.get('/permissions/:id', accessControlController.getPermission);
router.post('/permissions', accessControlController.createPermission);
router.put('/permissions/:id', accessControlController.updatePermission);

module.exports = router;
