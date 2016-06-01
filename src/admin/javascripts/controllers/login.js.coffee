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

            # if user is admin 
            if user.$has('administrators')
              user.getAdministratorsPromise().then () ->
                $scope.administrators = administrators

                # if user is admin in more than one company show select company
                if administrators.length > 1
                  $scope.template_vars.show_loading = false
                  $scope.template_vars.show_login = false
                  $scope.template_vars.show_pick_company = true
                else 
                # else automatically select the first admin
                  params =
                    email: $scope.login.email
                    password: $scope.login.password

                  $scope.login.selected_admin = _.first(administrators)  

                  $scope.login.selected_admin.$post('login', {}, params).then (login) ->
                    $scope.login.selected_admin.getCompanyPromise().then (company) ->
                      $scope.template_vars.show_loading = false
                      # if there are departments show department selector
                      if company.companies && company.companies.length > 0
                        $scope.template_vars.show_pick_department = true
                        $scope.departments = company.companies
                      else  
                      # else select that company directly and move on
                        $scope.login.selected_company = company  
                        AdminLoginService.setLogin($scope.login.selected_admin)
                        AdminLoginService.setCompany($scope.login.selected_company.id).then (user) ->
                          $scope.onSuccess($scope.login.selected_company)
            
            # else if there is an associated company
            else if user.$has('company')
              $scope.login.selected_admin = user
              user.getCompanyPromise().then (company) ->

                # if departments are available show departments selector
                if company.companies && company.companies.length > 0
                  $scope.template_vars.show_loading = false
                  $scope.template_vars.show_pick_department = true
                  $scope.template_vars.show_login = false
                  $scope.departments = company.companies
                else  
                # else select that company directly and move on
                  $scope.login.selected_company = company  
                  AdminLoginService.setLogin($scope.login.selected_admin)
                  AdminLoginService.setCompany($scope.login.selected_company.id).then (user) ->
                    $scope.onSuccess($scope.login.selected_company)
              , (err) ->
                $scope.template_vars.show_loading = false
                $scope.formErrors.push { message: "Sorry, there seems to be a problem with the company associated with this account"}

            else
              $scope.template_vars.show_loading = false
              $scope.formErrors.push { message: "Sorry, there seems to be a problem with this account"}
                            
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
        $scope.template_vars.show_loading = true
        if isValid
          $scope.bb.company = $scope.login.selected_company
          AdminLoginService.setLogin($scope.login.selected_admin)
          AdminLoginService.setCompany($scope.login.selected_company.id).then (user) ->
            $scope.onSuccess($scope.login.selected_company)
    ]
  }  
]