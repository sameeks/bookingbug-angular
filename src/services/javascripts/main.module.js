'use strict'

angular.module('BBAdminServices', [
  'BB',
  'BBAdmin.Services',
  'BBAdmin.Filters',
  'BBAdmin.Controllers',
  'trNgGrid',
  'ui.calendar',
])

angular.module('BBAdminServicesMockE2E', ['BBAdminServices', 'BBAdminMockE2E'])

