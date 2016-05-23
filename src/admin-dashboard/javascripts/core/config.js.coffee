'use strict'

angular.module('BBAdminDashboard.controllers', [])
angular.module('BBAdminDashboard.filters', [])
angular.module('BBAdminDashboard.services', [])
angular.module('BBAdminDashboard.directives', [])

BBAdminDashboardDependencies = [
  'ngStorage',
  'ngResource', 
  'ngTouch', 
  'ngSanitize',
  'ngIdle',
  'ngLocalData', 
  'ngInputDate', 

  'BBAdmin',
  'BBAdminServices',
  'BBAdminBooking',
  'BBAdmin.Directives',

  'ui.calendar', 
  'ui.bootstrap',
  'ui.router', 
  'ui.select',
  'ct.ui.router.extras',
  'trNgGrid',
  'xeditable', 
  'toggle-switch', 

  'BBAdminDashboard.controllers',
  'BBAdminDashboard.filters',
  'BBAdminDashboard.services',
  'BBAdminDashboard.directives',

  'BBAdminDashboard.check-in',
  'BBAdminDashboard.clients',
  'BBAdminDashboard.departments',
  'BBAdminDashboard.login',
  'BBAdminDashboard.logout',
  'BBAdminDashboard.calendar',
  'BBAdminDashboard.dashboard-iframe',
  'BBAdminDashboard.members-iframe',
  'BBAdminDashboard.settings-iframe',
  'BBAdminDashboard.config-iframe',
  'BBAdminDashboard.publish-iframe'
]

adminBookingApp = angular.module('BBAdminDashboard', BBAdminDashboardDependencies)
.config ['$stateProvider', '$urlRouterProvider', ($stateProvider, $urlRouterProvider) ->

  $stateProvider.root_state = "dashboard"

  $urlRouterProvider.otherwise("/" + $stateProvider.root_state)
  $stateProvider
    .state 'root',
      templateUrl: "admin_layout.html"
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
      controller: 'CorePageController'
]
.config ($logProvider, $httpProvider) ->
  $logProvider.debugEnabled(true)
  $httpProvider.defaults.withCredentials = true

.constant('idleTimeout', 600)
.constant('idleStart', 300)
.value 'company_id', null
.value 'sso_token', false

.config ($idleProvider, idleStart, idleTimeout) ->
  $idleProvider.idleDuration(idleStart)
  $idleProvider.warningDuration(idleTimeout)
