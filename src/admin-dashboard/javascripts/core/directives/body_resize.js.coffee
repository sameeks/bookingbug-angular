'use strict'

###*
 * @ngdoc directive
 * @name BBAdminDashboard.directive:bodyResize
 * @scope
 * @restrict A
 *
 * @description
 * Toggle side-menu based on window size
 *
 * @param {object}  field   A field object
###
angular.module('BBAdminDashboard').directive 'bodyResize', ['$window', '$timeout', 'AdminCoreOptions', 'PageLayout', ($window, $timeout, AdminCoreOptions, PageLayout) ->
  {
    restrict: 'A'
    link: (scope, element) ->
      $timeout (->
        _sideMenuSetup(true)
        return
      ), 0
      angular.element($window).bind 'resize', ->
        _sideMenuSetup()
        return

      _sideMenuSetup = (firstLoad = false) ->
        if $window.innerWidth > 768 && (!firstLoad || AdminCoreOptions.sidenav_start_open) && !AdminCoreOptions.deactivate_sidenav
          PageLayout.sideMenuOn = true
        else
          PageLayout.sideMenuOn = false
        return

      return
  }
]
