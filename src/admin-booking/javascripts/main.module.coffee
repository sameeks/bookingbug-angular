'use strict'

angular.module('BBAdminBooking', [
  'BB'
  'BBAdmin.Services'
  'BBAdminServices'
  'trNgGrid'
])

angular.module('BBAdminBooking.Directives', [])

angular.module('BBAdminBooking.Services', [
  'ngResource'
  'ngSanitize'
])

angular.module('BBAdminBooking.Controllers', [
  'ngLocalData'
  'ngSanitize'
])