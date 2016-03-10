'use strict'

angular.module('BB').directive 'lteBody', () ->
  restrict: 'AE'
  replace: true
  scope : true
  link : (scope, element, attrs) ->
    scope.adminlte ||= {}

    scope.setPageTitle = (title) ->
      $scope.adminlte.title  = title

    scope.setPageSubtitle = (subtitle) ->
      $scope.adminlte.subtitle  = subtitle

    scope.$watch 'adminlte.side_menu', (val) ->
      if val
        element.removeClass('no-side-menu')
      else
        element.addClass('no-side-menu')


angular.module('BB').directive 'lteSideMenu', () ->
  restrict: 'AE'
  link : (scope, element, attrs) ->
    scope.adminlte.side_menu = attrs.lteSideMenu


angular.module('BB').directive 'lteNoSideMenu', () ->
  restrict: 'AE'
  link : (scope, element, attrs) ->
    if scope.adminlte
      scope.adminlte.side_menu = null


angular.module('BB').directive 'lteHeading', () ->
  restrict: 'AE'
  link : (scope, element, attrs) ->
    scope.adminlte.heading = attrs.lteHeading


angular.module('BBAdminDashboard').directive 'bbDashboardSidebarWrapper', ($window) ->
  restrict: 'AE'
  templateUrl: 'dashboard_sidebar_wrapper.html'
  transclude: true
  link: (scope, element, attrs) ->
    scope.adminlte.side_menu = true
    if $window.$.AdminLTE.pushMenu
      $window.$.AdminLTE.pushMenu.activate($window.$.AdminLTE.options.sidebarToggleSelector)


angular.module('BBAdminDashboard').directive 'bbDashboardContentWrapper', ($window, $rootScope) ->
  restrict: 'AE'
  templateUrl: 'dashboard_content_wrapper.html'
  transclude: true
  link: (scope, element, attrs) ->
    $window.addEventListener 'message', (event) =>
      if event.data.height && !scope.adminlte.fixed_page
        scope.$apply ->
          scope.adminlte.iframe_style = {height:"#{event.data.height}px"}
          $window.$.AdminLTE.layout.fix()
          $window.$.AdminLTE.layout.fixSidebar()


angular.module('BBAdminDashboard').directive 'lteFixHeight', ($window) ->
  link: (scope, element, attrs) ->
    if $window.$.AdminLTE && $window.$.AdminLTE.layout
      $window.$.AdminLTE.layout.fix()
      $window.$.AdminLTE.layout.fixSidebar()


angular.module('BBAdminDashboard').directive 'ltePinBottom', ($window, $bbug) ->
  restrict: 'AE'
  link: (scope, element, attrs) ->
    if scope.adminlte.fixed_page
      scope.adminlte.iframe_style = ""
      pos = $bbug(element).position()
      $bbug(element).height("" + ($window.innerHeight-pos.top)+ "px")
      angular.element($window).bind 'resize', ->
        pos = $bbug(element).position()
        $bbug(element).height("" + ($window.innerHeight-pos.top)+ "px")
