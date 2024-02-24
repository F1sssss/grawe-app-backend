const accessControlController = require('../controllers/accessControlController');
const router = require('express').Router();

router.get('/groups', accessControlController.getGroups);
router.get('/groups/:id', accessControlController.getGroup);
router.post('/groups', accessControlController.createGroup);
router.patch('/groups/:id', accessControlController.updateGroup);
router.delete('/groups/properties', accessControlController.removePermissionFromGroup);
router.delete('/groups/:id', accessControlController.deleteGroup);

router.get('/properties', accessControlController.getPermissions);
router.get('/properties/:id', accessControlController.getPermission);
router.post('/properties/:id', accessControlController.createPermissionProperties);
router.post('/properties', accessControlController.createPermission);
router.patch('/properties/:id', accessControlController.updatePermission);

router.patch('/properties/:id/rights', accessControlController.updatePermissionRigths);
router.put('/groups/properties/', accessControlController.addPermissionToGroup);
router.delete('/properties/:id', accessControlController.deletePermission);

router.get('/users/:id/groups', accessControlController.getUsersGroups);

module.exports = router;
