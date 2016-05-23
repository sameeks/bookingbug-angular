'use strict'

###
 * @ngdoc directive
 * @name BBAdminDashboard.directives.directive:bodyResize
 * @scope
 * @restrict A
 *
 * @description
 * Toggle side-menu based on window size
 *
 * @param {object}  field   A field object
###
angular.module('BBAdminDashboard.directives').directive 'bodyResize', ['$window', '$timeout', ($window, $timeout) ->
  {
    restrict: 'A'
    link: (scope, element) ->
      $timeout (->
        _sideMenuSetup()
        return
      ), 0
      angular.element($window).bind 'resize', ->
        _sideMenuSetup()
        return

      _sideMenuSetup = ->
        if $window.innerWidth > 768
          scope.page.sideMenuOn = true
        else
          scope.page.sideMenuOn = false
        scope.$apply()
        return

      return
  }
]