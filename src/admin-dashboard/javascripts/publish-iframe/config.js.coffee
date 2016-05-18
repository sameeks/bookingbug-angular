'use strict'

angular.module('BBAdminDashboard.publish-iframe.controllers', [])
angular.module('BBAdminDashboard.publish-iframe.services', [])
angular.module('BBAdminDashboard.publish-iframe.directives', [])

angular.module('BBAdminDashboard.publish-iframe', [
  'BBAdminDashboard.publish-iframe.controllers',
  'BBAdminDashboard.publish-iframe.services',
  'BBAdminDashboard.publish-iframe.directives'
])
.config ['$stateProvider', '$urlRouterProvider', ($stateProvider, $urlRouterProvider) ->
  $stateProvider
    .state 'publish',
      parent: 'root'
      url: '/publish'
      templateUrl: 'admin_publish_page.html'
      controller: 'PublishIframePageCtrl'

    .state 'publish.page',
      parent: 'publish'
      url: '/page/:path'
      templateUrl: 'iframe_page.html'
      controller: 'PublishSubIframePageCtrl'
      
]