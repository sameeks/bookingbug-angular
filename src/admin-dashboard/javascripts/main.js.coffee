'use strict'

adminbookingapp = angular.module('BBAdminDashboard', [
  'trNgGrid',
  'BBAdmin',
  'BBAdminServices',
  'ui.calendar',
  'ngStorage',
  'BBAdminBooking',
  'BBAdmin.Directives',
  'ui.calendar', 'ngResource', 'ui.bootstrap',
  'ui.router', 'ct.ui.router.extras','ngTouch', 'ngInputDate', 'ngSanitize',
  'xeditable', 'ngIdle', 'ngLocalData', 'toggle-switch', 'ui.select'
])

angular.module('BBAdminDashboard').config ($logProvider, $httpProvider) ->
  $logProvider.debugEnabled(true)
  $httpProvider.defaults.withCredentials = true

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

# Default values (expect to be overriden in bespoke) 
angular.module('BBAdminDashboard').value 'company_id', null
angular.module('BBAdminDashboard').value 'sso_token', false

angular.module('BBAdminDashboard').config ($stateProvider, $urlRouterProvider) ->
  $stateProvider.root_state = "dashboard"

  $urlRouterProvider.otherwise("/" + $stateProvider.root_state)
  $stateProvider
    .state 'root',
      template: "<div ui-view></div>"
      resolve:
        sso: ($q, sso_token, AdminLoginService, $injector) ->
          defer = $q.defer()

          AdminLoginService.isLoggedIn().then (loggedIn)-> 
            if not loggedIn and sso_token != false
              # Use the injector to avoid errors for including a 
              # service with dependencies on construct (AdminSsoLogin requires company_id value)
              AdminSsoLogin = $injector.get 'AdminSsoLogin'

              AdminSsoLogin sso_token, (admin)->
                AdminLoginService.setLogin admin
                defer.resolve()  
            else 
              defer.resolve()   

          defer.promise  

        user: ($q, AdminLoginService, $timeout, $state, sso) ->
          defer = $q.defer()
          AdminLoginService.user().then (user) ->
            if user
              defer.resolve(user)
            else
              $timeout () ->
                $state.go 'login', {}, {reload: true}
          , (err) ->
            $timeout () ->
              $state.go 'login', {}, {reload: true}
          defer.promise
        company: (user, $q, $timeout, $state) ->
          defer = $q.defer()
          user.getCompanyPromise().then (company) ->
            if company.companies && company.companies.length > 0
              $timeout () ->
                $state.go 'departments', {}, {reload: true}
            else
              defer.resolve(company)
          , (err) ->
            $timeout () ->
              console.log('failed to get company')
              $state.go 'login', {}, {reload: true}
          defer.promise
      controller: 'bbAdminRootPageController'
    .state 'departments',
      url: "/departments"
      controller: ($scope, company, departments, AdminLoginService, $state, $timeout) ->
        $scope.company = company
        $scope.departments = departments

        $scope.selectDepartment = (department) ->
          AdminLoginService.setCompany(department.id).then (user) ->
            $timeout () ->
              $state.go $stateProvider.root_state, {}, {reload: true}

      templateUrl: "admin_departments_page.html"
      resolve:
        user: ($q, AdminLoginService, $timeout, $state) ->
          defer = $q.defer()
          AdminLoginService.user().then (user) ->
            if user
              defer.resolve(user)
            else
              $timeout () ->
                $state.go 'login', {}, {reload: true}
          , (err) ->
            $timeout () ->
              $state.go 'login', {}, {reload: true}
          defer.promise
        company: (user) -> user.getCompanyPromise()
        departments: (company, $q, $timeout, $state) ->
          defer = $q.defer()
          if company.companies && company.companies.length > 0
            defer.resolve(company.companies)
          else
            $timeout () ->
              $state.go $stateProvider.root_state, {}, {reload: true}
          defer.promise
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
      deepStateRedirect: {
        default: { state: "settings.page", params: { path: "person" } }
        params: true
      }
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
      controller: (AdminLoginService, $state, $timeout) ->
        AdminLoginService.logout()
        $timeout () ->
          $state.go 'login', {}, {reload: true}
    .state 'checkin',
      parent: 'root'
      url: "/checkin"
      templateUrl: "checkin_page.html"
      controller: ($scope, $stateParams) ->
        $scope.adminlte.heading = 'Check-in'
    .state 'clients',
      parent: 'root'
      url: "/clients"
      templateUrl: "admin_clients.html"
      controller: ($scope) ->
        $scope.adminlte.heading = null
        $scope.clientsOptions = {search: null}
        $scope.adminlte.side_menu = true

        $scope.set_current_client = (client) ->
          $scope.current_client = client
    .state 'clients.new',
      url: "/new"
      templateUrl: "client_new.html"
    .state 'clients.all',
      url: "/all"
      templateUrl: "all_clients.html"
      controller: ($scope) ->
        $scope.set_current_client(null)
    .state 'clients.edit',
      url: "/edit/:id"
      templateUrl: "admin_client.html"
      resolve:
        client: (company, $stateParams, AdminClientService) ->
          params =
            company_id: company.id
            id: $stateParams.id
          AdminClientService.query(params)
      controller: ($scope, client, $state, company, AdminClientService) ->
        $scope.client = client
        $scope.historicalStartDate = moment().add(-1, 'years')
        $scope.historicalEndDate = moment()
        # Refresh Client Resource after save
        $scope.memberSaveCallback = ()->
          params =
            company_id: company.id
            id: $state.params.id
            flush: true

          AdminClientService.query(params).then (client)->
            $scope.client = client
    .state 'calendar',
      parent: 'root'
      url: "/calendar/:assets"
      templateUrl: "calendar_page.html"
      controller: ($scope) ->
        $scope.adminlte.side_menu = false
        $scope.adminlte.heading = null

