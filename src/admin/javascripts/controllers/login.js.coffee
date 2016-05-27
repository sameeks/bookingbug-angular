'use strict'

###
 * @ngdoc directive
 * @name BBAdmin.Directives.directive:bbAdminLogin
 * @scope
 * @restrict A
 *
 * @description
 * Admin login journey directive
 *
 * @param {object}  field   A field object
###
angular.module('BBAdmin.Directives').directive 'bbAdminLogin', [() ->
  {
    restrict: 'AE'
    replace: true
    scope: {
      onSuccess: '='
      onCancel: '='
      onError: '='
      bb: '='
    }
    templateUrl: 'admin_login.html'
    controller: ['$scope', '$rootScope', 'AdminLoginService', '$q', '$sessionStorage', ($scope, $rootScope, AdminLoginService, $q, $sessionStorage)->
      $scope.template_vars =
        show_login: true
        show_pick_company: false
        show_pick_department: false
        show_loading: false

      $scope.login =
        host: $sessionStorage.getItem('host')
        email: null
        password: null
        selected_admin: null
        selected_company: null

      $scope.login = (isValid) ->
        if isValid
          $scope.template_vars.show_loading = true
          $scope.formErrors = []

          params =
            email: $scope.login.email
            password: $scope.login.password
          AdminLoginService.login(params).then (user) ->
            if user.company_id?
              $scope.template_vars.show_loading = false
              $scope.user = user
              $scope.onSuccess() if $scope.onSuccess
            else
              user.getAdministratorsPromise().then (administrators) ->
                $scope.template_vars.show_loading = false
                $scope.template_vars.show_login = false
                $scope.template_vars.show_pick_company = true

                $scope.administrators = administrators
          , (err) ->
            $scope.template_vars.show_loading = false
            $scope.formErrors.push { message: "Sorry, either your email or password was incorrect"}

      $scope.pickCompany = ()->
        $scope.template_vars.show_loading = true
        $scope.template_vars.show_pick_department = false

        params =
          email: $scope.login.email
          password: $scope.login.password
        $scope.login.selected_admin.$post('login', {}, params).then (login) ->
          $scope.login.selected_admin.getCompanyPromise().then (company) ->
            $scope.template_vars.show_loading = false

            if company.companies && company.companies.length > 0
              $scope.template_vars.show_pick_department = true
              $scope.departments = company.companies
            else  
              $scope.login.selected_company = company


      $scope.selectCompanyDepartment = (isValid) ->
        if isValid
          $scope.bb.company = $scope.login.selected_company
          AdminLoginService.setLogin($scope.login.selected_admin)
          AdminLoginService.setCompany($scope.login.selected_company.id).then (user) ->
            $scope.onSuccess($scope.login.selected_company)
    ]
  }  
]