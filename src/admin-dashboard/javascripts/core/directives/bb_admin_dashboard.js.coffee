angular.module('BBAdminDashboard').directive 'bbAdminDashboard', (PageLayout) ->
  restrict: 'AE'
  scope:
    bb: '='
    companyId: '@'
    ssoToken: '@'
    env: '@'
  template: '<div ui-view></div>'
  controller: ['$scope', '$rootScope', '$localStorage', '$state', 'PageLayout', 'AdminSsoLogin', 'AdminLoginOptions'
    ($scope, $rootScope, $localStorage, $state, PageLayout, AdminSsoLogin, AdminLoginOptions)->

      $rootScope.bb = $scope.bb
      $rootScope.environment = $scope.env

      api_url = $localStorage.getItem("api_url")
      if !$scope.bb.api_url && api_url
        $scope.bb.api_url = api_url

      # Set this up globally for everyone
      AdminSsoLogin.apiUrl    = $scope.bb.api_url
      AdminSsoLogin.ssoToken  = if $scope.ssoToken? then $scope.ssoToken else AdminLoginOptions.sso_token
      AdminSsoLogin.companyId = if $scope.companyId? then $scope.companyId else AdminLoginOptions.company_id

      $scope.$on '$stateChangeError', (evt, to, toParams, from, fromParams, error) ->
        switch error.reason
          when 'NOT_LOGGABLE_ERROR'
            evt.preventDefault()
            $state.go 'login'
          when 'COMPANY_IS_PARENT'
            evt.preventDefault()
            $state.go 'login'

      $scope.openSideMenu = ()->
        PageLayout.sideMenuOn = true

      $scope.closeSideMenu = ()->
        PageLayout.sideMenuOn = false

      $scope.toggleSideMenu = ()->
        PageLayout.sideMenuOn = !PageLayout.sideMenuOn

      return

  ]
  link: (scope, element, attrs)->

    scope.page = PageLayout

    scope.$watch 'page', (newPage,oldPage)->
      if newPage.sideMenuOn
        element.addClass('sidebar-open')
        element.removeClass('sidebar-collapse')
      else
        element.addClass('sidebar-collapse')
        element.removeClass('sidebar-open')

      if newPage.boxed
        element.addClass('layout-boxed')
      else
        element.removeClass('layout-boxed')

    , true