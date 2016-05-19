'use strict'

angular.module('BBAdminDashboard.members-iframe.controllers', [])
angular.module('BBAdminDashboard.members-iframe.services', [])
angular.module('BBAdminDashboard.members-iframe.directives', [])

angular.module('BBAdminDashboard.members-iframe', [
  'BBAdminDashboard.members-iframe.controllers',
  'BBAdminDashboard.members-iframe.services',
  'BBAdminDashboard.members-iframe.directives'
])
.config ['$stateProvider', '$urlRouterProvider', ($stateProvider, $urlRouterProvider) ->
  $stateProvider
    .state 'members',
      parent: 'root'
      url: '/members'
      templateUrl: 'admin_members_page.html'
      controller: 'MembersIframePageCtrl'

    .state 'members.page',
      parent: 'members'
      url: '/page/:path/:id'
      templateUrl: 'iframe_page.html'
      controller: 'MembersSubIframePageCtrl'
]