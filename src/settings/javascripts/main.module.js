angular.module('BBAdminSettings', [
    'BB',
    'BBAdmin.Services',
    'BBAdmin.Filters',
    'BBAdmin.Controllers',
    'trNgGrid'
]);

angular.module('BBAdminSettingsMockE2E', ['BBAdminSettings', 'BBAdminMockE2E']);
