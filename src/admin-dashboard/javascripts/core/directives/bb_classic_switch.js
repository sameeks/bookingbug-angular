'use strict'

###*
 * @ngdoc directive
 * @name BBAdminDashboard.directive:bbClassicSwitch
 * @scope
 * @restrict A
 *
 * @description
 * Create a link that switches back to BB Classic mode
 *
###
angular.module('BBAdminDashboard').directive 'bbClassicSwitch', [() ->
  {
    restrict: 'A'
    scope: false
    link: (scope, element, attrs) ->
      if scope.bb.api_url
        attrs.$set('href', scope.bb.api_url + "?dashboard_redirect=true")
  }
]
