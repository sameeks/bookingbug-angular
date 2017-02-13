angular.module('BBAdminEvents', [
  'BB',
  'BBAdmin.Services',
  'BBAdmin.Filters',
  'BBAdmin.Controllers',
  'trNgGrid'
]);

angular.module('BBAdminEventsMockE2E', ['BBAdminEvents', 'BBAdminMockE2E']);

