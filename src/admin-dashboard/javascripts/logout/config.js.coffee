'use strict'

angular.module('BBAdminDashboard.logout.controllers', [])
angular.module('BBAdminDashboard.logout.services', [])
angular.module('BBAdminDashboard.logout.directives', [])

angular.module('BBAdminDashboard.logout', [
  'BBAdminDashboard.logout.controllers',
  'BBAdminDashboard.logout.services',
  'BBAdminDashboard.logout.directives'
])
.config ['$stateProvider', '$urlRouterProvider', ($stateProvider, $urlRouterProvider) ->
  $stateProvider
    .state 'logout',
      url: '/logout'
      controller: 'LogoutPageCtrl'
      resolve: {
        loadModule: ['$ocLazyLoad', '$rootScope', ($ocLazyLoad, $rootScope) ->
          if $rootScope.environment == 'development'
            script = 'bb-angular-admin-dashboard-logout.lazy.js'
          else
            script = 'bb-angular-admin-dashboard-logout.lazy.min.js'
          $ocLazyLoad.load(script);
        ]
      }
]