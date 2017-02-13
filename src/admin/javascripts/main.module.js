'use strict'

angular.module('BBAdmin', [
  'BB',
  'BBAdmin.Services',
  'BBAdmin.Filters',
  'BBAdmin.Directives',
  'BBAdmin.Controllers',
  'BBAdmin.Models',
  'BBAdmin.Directives',
  'trNgGrid'
])

angular.module('BBAdmin.Directives', [])

angular.module('BBAdmin.Filters', [])

angular.module('BBAdmin.Models', [])

angular.module('BBAdmin.Services', [
  'ngResource',
  'ngSanitize',
])

angular.module('BBAdmin.Controllers', [
  'ngSanitize'
])


