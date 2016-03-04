'use strict'

adminbookingapp = angular.module('BBAdminDashboard', [
  'trNgGrid',
  'BBAdmin',
  'BBAdminServices',
  'ui.calendar',
  'ngStorage',
  'BBAdminBooking',
  'BBAdminDashboard',
  'BBAdmin.Directives',
  'ui.calendar', 'ngResource', 'ui.bootstrap',
  'ui.router', 'ngTouch', 'ngInputDate', 'ngSanitize',
  'xeditable', 'ngIdle', 'ngLocalData'
])

angular.module('BBAdminDashboard').config ($logProvider) ->
  $logProvider.debugEnabled(true)

angular.module('BBAdminDashboard.Directives', [])

angular.module('BBAdminDashboard.Services', [
  'ngResource',
  'ngSanitize'
  'ngLocalData'
])

angular.module('BBAdminDashboard.Controllers', [
  'ngLocalData',
  'ngSanitize'
])

angular.module('BBAdminDashboard').run (editableOptions) ->
  editableOptions.theme = 'bs3'

angular.module('BBAdminDashboard').constant('idleTimeout', 600)
angular.module('BBAdminDashboard').constant('idleStart', 300)

angular.module('BBAdminDashboard').config ($idleProvider, idleStart, idleTimeout) ->
  $idleProvider.idleDuration(idleStart)
  $idleProvider.warningDuration(idleTimeout)

angular.module('BBAdminDashboard').config ($stateProvider, $urlRouterProvider) ->

  $urlRouterProvider.otherwise("/dashboard")
  $stateProvider
    .state 'root',
      template: "<div ui-view></div>"
      resolve:
        user: ($q, AdminLoginService, $timeout, $state) ->
          defer = $q.defer()
          $q.when(AdminLoginService.checkLogin()).then () ->
            unless AdminLoginService.isLoggedIn()
              $timeout () ->
                $state.go 'login', {}, {reload: true}
            else
              defer.resolve(AdminLoginService.user())
          , (err) ->
            $timeout () ->
              $state.go 'login', {}, {reload: true}
          defer.promise
        company: (user, $q, $timeout, $state) ->
          console.log(user)
          defer = $q.defer()
          user.getCompanyPromise().then (company) ->
            defer.resolve(company)
          , (err) ->
            $timeout () ->
              console.log('failed to get company')
              $state.go 'login', {}, {reload: true}
          defer.promise
        services: (company) -> []
        resources: (company) -> []
        people: (company) -> []
        addresses: (company, AdminAddressService) -> []
      controller: 'bbAdminRootPageController'
    .state 'dashboard',
      parent: "root"
      url: "/dashboard"
      controller: "bbAdminDashboardPageController"
      templateUrl: "admin_dashboard_page.html"
    .state 'dashboard.page',
      parent: "dashboard"
      url: "/page/:path"
      templateUrl: "iframe_page.html"
      controller: ($scope, $stateParams) ->
        $scope.path = $stateParams.path
    .state 'view',
      parent: "root"
      url: "/view"
      templateUrl: "admin_view_page.html"
    .state 'view.page',
      parent: "view"
      url: "/page/:path"
      templateUrl: "iframe_page.html"
      controller: ($scope, $stateParams) ->
        $scope.path = $stateParams.path
    .state 'page',
      parent: "root"
      url: "/page/:path"
      templateUrl: "iframe_page.html"
      controller: ($scope, $stateParams) ->
        $scope.path = $stateParams.path
    .state 'members',
      parent: "root"
      url: "/members"
      controller: "bbAdminMembersPageController"
      templateUrl: "admin_members_page.html"
    .state 'members.page',
      parent: "members"
      url: "/page/:path/:id"
      templateUrl: "iframe_page.html"
      controller: ($scope, $stateParams) ->
        $scope.path = $stateParams.path
        if $stateParams.id
          $scope.extra_params = "id=#{$stateParams.id}"
        else
          $scope.extra_params = ""
    .state 'config',
      parent: "root"
      url: "/config"
      controller: "bbAdminConfigPageController"
      templateUrl: "admin_config_page.html"
    .state 'config.page',
      url: "/page/:path"
      templateUrl: "iframe_page.html"
      controller: ($scope, $stateParams) ->
        $scope.path = $stateParams.path
    .state 'settings',
      parent: "root"
      url: "/settings"
      templateUrl: "admin_settings_page.html"
    .state 'settings.page',
      parent: "settings"
      url: "/page/:path"
      templateUrl: "iframe_page.html"
      controller: ($scope, $stateParams) ->
        $scope.path = $stateParams.path
    .state 'publish',
      parent: "root"
      url: "/publish"
      controller: "bbAdminPublishPageController"
      templateUrl: "admin_publish_page.html"
    .state 'publish.page',
      parent: "publish"
      url: "/page/:path"
      templateUrl: "iframe_page.html"
      controller: ($scope, $stateParams) ->
        $scope.path = $stateParams.path
    .state 'login',
      url: "/login"
      controller: "bbAdminLoginPageController"
      templateUrl: "admin_login_page.html"
    .state 'logout',
      url: "/logout"
      controller: (AdminLoginService, $state) ->
        AdminLoginService.logout()
        $state.go 'login', {}, {reload: true}

