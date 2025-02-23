const accessControlController = require('../controllers/accessControlController');
const authController = require('../controllers/authController');

const router = require('express').Router();

router.use(authController.protect);

router.get('/hierarchy/groups', accessControlController.getHierarchyGroups);
router.get('/hierarchy/groups/:id', accessControlController.getHierarchyGroup);
router.get('/hierarchy/my-groups', accessControlController.getUserHierarchyGroups);
router.get('/hierarchy/groups/:id/vktos', accessControlController.getGroupVKTOs);
router.post('/hierarchy/groups', accessControlController.createHierarchyGroup);
router.patch('/hierarchy/groups/:id', accessControlController.updateHierarchyGroup);
router.delete('/hierarchy/groups/:id', accessControlController.deleteHierarchyGroup);
router.post('/hierarchy/groups/:id/users', accessControlController.addUserToHierarchyGroup);
router.delete('/hierarchy/groups/:id/users', accessControlController.removeUserFromHierarchyGroup);

router.get('/groups', accessControlController.getGroups);
router.get('/groups/:id', accessControlController.getGroup);
router.post('/groups', accessControlController.createGroup);
router.patch('/groups/:id', accessControlController.updateGroup);
router.delete('/groups/properties', accessControlController.removePermissionFromGroup);
router.delete('/groups/:id', accessControlController.deleteGroup);
router.post('/groups/:id/users', accessControlController.addUserToGroup);
router.delete('/groups/:id/users', accessControlController.removeUserFromGroup);

router.get('/properties', accessControlController.getPermissions);
router.get('/properties/:id', accessControlController.getPermission);
router.post('/properties/:id', accessControlController.createPermissionProperties);
router.post('/properties', accessControlController.createPermission);
router.patch('/properties/:id', accessControlController.updatePermission);

router.patch('/properties/:id/rights', accessControlController.updatePermissionRights);
//router.put('/groups/properties/', accessControlController.addPermissionToGroup);
router.delete('/properties/:id', accessControlController.deletePermission);

router.get('/users/:id/groups', accessControlController.getUsersGroups);

module.exports = router;
