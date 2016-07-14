'use strict'

angular.module('BBAdminDashboard.departments.controllers', [])
angular.module('BBAdminDashboard.departments.services', [])
angular.module('BBAdminDashboard.departments.directives', [])
angular.module('BBAdminDashboard.departments.translations', [])

angular.module('BBAdminDashboard.departments', [
  'BBAdminDashboard.departments.controllers',
  'BBAdminDashboard.departments.services',
  'BBAdminDashboard.departments.directives',
  'BBAdminDashboard.departments.translations'
])
.config ($stateProvider, $urlRouterProvider) ->
  $stateProvider
    .state 'departments',
      url: "/departments"
      templateUrl: "admin_departments_page.html"
      resolve:
        user: ($q, BBModel, $timeout, $state) ->
          defer = $q.defer()
          BBModel.Admin.Login.$user().then (user) ->
            if user
              defer.resolve(user)
            else
              $timeout () ->
                $state.go 'login', {}, {reload: true}
          , (err) ->
            $timeout () ->
              $state.go 'login', {}, {reload: true}
          defer.promise
        company: (user) -> user.$getCompany()
        departments: (company, $q, $timeout, $state) ->
          defer = $q.defer()
          if company.companies && company.companies.length > 0
            defer.resolve(company.companies)
          else
            $timeout () ->
              $state.go $stateProvider.root_state, {}, {reload: true}
          defer.promise
      controller: 'DepartmentsPageCtrl'

