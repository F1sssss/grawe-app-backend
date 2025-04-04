const accessControlController = require('../controllers/accessControlController');
const authController = require('../controllers/authController');

const router = require('express').Router();

router.use(authController.protect);

router.get('/hierarchy/groups', accessControlController.getHierarchyGroups);
router.get('/hierarchy/groups/:id', accessControlController.getHierarchyGroup);
router.get('/hierarchy/my-groups', accessControlController.getUserHierarchyGroups);
router.get('/hierarchy/groups/:id/vktos', accessControlController.getGroupVKTOs);
router.get('/hierarchy/groups/:id/users', accessControlController.getUsersInHierarchyGroup);
router.get('/hierarchy/vktos', accessControlController.getAllVKTOs);
router.post('/hierarchy/groups', accessControlController.createHierarchyGroup);
router.post('/hierarchy/groups/:id/vktos', accessControlController.addVKTOToHierarchyGroup);
router.patch('/hierarchy/groups/:id', accessControlController.updateHierarchyGroup);
router.delete('/hierarchy/groups/:id', accessControlController.deleteHierarchyGroup);
router.delete('/hierarchy/groups/:id/vktos', accessControlController.removeVKTOFromHierarchyGroup);
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

router.get('/property-list', accessControlController.getProperties);
router.post('/property-list', accessControlController.addProperty);
router.get('/properties/:id/property-items', accessControlController.getPermissionProperties);
router.post('/properties/:id/property-items', accessControlController.addPermissionProperty);
router.delete('/properties/:id/property-items', accessControlController.deletePermissionProperty);

router.get('/users/:id/groups', accessControlController.getUsersGroups);

module.exports = router;
