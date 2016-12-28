'use strict'

###
 * @ngdoc directive
 * @name BBAdminDashboard.login.directives.directive:adminDashboardLogin
 * @scope
 * @restrict A
 *
 * @description
 * Admin login journey directive
 *
 * @param {object}  field   A field object
###
angular.module('BBAdminDashboard.login.directives').directive 'adminDashboardLogin', [() ->
  {
    restrict: 'AE'
    replace: true
    scope: {
      onSuccess: '='
      onCancel: '='
      onError: '='
      bb: '='
      user: '=?'
    }
    templateUrl: 'login/admin-dashboard-login.html'
    controller: ($scope, $rootScope, BBModel, $q, $localStorage, $state, AdminLoginOptions) ->
      'ngInject'

      $scope.template_vars =
        show_api_field: AdminLoginOptions.show_api_field
        show_login: true
        show_pick_company: false
        show_pick_department: false
        show_loading: false

      $scope.login_data =
        email: null
        password: null
        selected_admin: null
        selected_company: null
        site: $localStorage.getItem("api_url")

      $scope.formErrors = []

      formErrorExists = (message) ->
        # iterate through the formErrors array
        for obj in $scope.formErrors
          # check if the message passed in matches any pre-existing ones.
          if obj.message.match message
            return true
        return false

      companySelection = (user) ->
        # if user is admin
        if user.$has('administrators')
          user.$getAdministrators().then (administrators) ->
            $scope.administrators = administrators

            # if user is admin in more than one company show select company
            if administrators.length > 1
              $scope.template_vars.show_loading = false
              $scope.template_vars.show_login = false
              $scope.template_vars.show_pick_company = true
            else if administrators.length == 1
            # else automatically select the first admin
              params =
                email: $scope.login_data.email
                password: $scope.login_data.password

              $scope.login_data.selected_admin = _.first(administrators)
              $scope.login_data.selected_admin.$post('login', {}, params).then (login) ->
                $scope.login_data.selected_admin.$getCompany().then (company) ->
                  $scope.template_vars.show_loading = false
                  # if there are departments show department selector
                  if company.companies && company.companies.length > 0
                    $scope.template_vars.show_pick_department = true
                    $scope.departments = company.companies
                  else
                  # else select that company directly and move on
                    $scope.login_data.selected_company = company
                    BBModel.Admin.Login.$setLogin($scope.login_data.selected_admin)
                    BBModel.Admin.Login.$setCompany($scope.login_data.selected_company.id).then (user) ->
                      $scope.onSuccess($scope.login_data.selected_company)
            else
              $scope.template_vars.show_loading = false
              message = "ADMIN_DASHBOARD.LOGIN_PAGE.ERROR_INCORRECT_CREDS"
              $scope.formErrors.push { message: message } if !formErrorExists message

        # else if there is an associated company
        else if user.$has('company')
          $scope.login_data.selected_admin = user

          user.$getCompany().then (company) ->
            # if departments are available show departments selector
            if company.companies && company.companies.length > 0
              $scope.template_vars.show_loading = false
              $scope.template_vars.show_pick_department = true
              $scope.template_vars.show_login = false
              $scope.departments = company.companies
            else
            # else select that company directly and move on
              $scope.login_data.selected_company = company
              BBModel.Admin.Login.$setLogin($scope.login_data.selected_admin)
              BBModel.Admin.Login.$setCompany($scope.login_data.selected_company.id).then (user) ->
                $scope.onSuccess($scope.login_data.selected_company)
          , (err) ->
            $scope.template_vars.show_loading = false
            message = "ADMIN_DASHBOARD.LOGIN_PAGE.ERROR_ISSUE_WITH_COMPANY"
            $scope.formErrors.push { message: message } if !formErrorExists message

        else
          $scope.template_vars.show_loading = false
          message = "ADMIN_DASHBOARD.LOGIN_PAGE.ERROR_ACCOUNT_ISSUES"
          $scope.formErrors.push { message: message } if !formErrorExists message

      # If a User is available at this stages SSO login is implied
      if $scope.user
        $scope.template_vars.show_pick_department = true
        $scope.template_vars.show_login = false
        companySelection($scope.user)

      $scope.login = (isValid) ->
        if isValid
          $scope.template_vars.show_loading = true

          #if the site field is used set the api url to the submmited url
          if AdminLoginOptions.show_api_field
            # strip trailing spaces from the url to avoid calling an invalid endpoint
            # since all service calls to api end-points begin with '/', e.g '/api/v1/...'
            $scope.login_data.site = $scope.login_data.site.replace(/\/+$/, '')
            if $scope.login_data.site.indexOf("http") == -1
              $scope.login_data.site = "https://" + $scope.login_data.site
            $scope.bb.api_url = $scope.login_data.site
            $rootScope.bb.api_url = $scope.login_data.site
            $localStorage.setItem("api_url", $scope.login_data.site)

          params =
            email: $scope.login_data.email
            password: $scope.login_data.password
          BBModel.Admin.Login.$login(params).then (user) ->
            companySelection(user)

          , (err) ->
            $scope.template_vars.show_loading = false
            message = "ADMIN_DASHBOARD.LOGIN_PAGE.ERROR_INCORRECT_CREDS"
            $scope.formErrors.push { message: message } if !formErrorExists message

      $scope.goToResetPassword = () ->
        $state.go 'reset-password'

      $scope.pickCompany = ()->
        $scope.template_vars.show_loading = true
        $scope.template_vars.show_pick_department = false

        params =
          email: $scope.login_data.email
          password: $scope.login_data.password

        $scope.login_data.selected_admin.$post('login', {}, params).then (login) ->
          $scope.login_data.selected_admin.$getCompany().then (company) ->
            $scope.template_vars.show_loading = false

            if company.companies && company.companies.length > 0
              $scope.template_vars.show_pick_department = true
              $scope.departments = company.companies
            else
              $scope.login_data.selected_company = company

      $scope.selectCompanyDepartment = (isValid) ->
        $scope.template_vars.show_loading = true
        if isValid
          $scope.bb.company = $scope.login_data.selected_company
          BBModel.Admin.Login.$setLogin($scope.login_data.selected_admin)
          BBModel.Admin.Login.$setCompany($scope.login_data.selected_company.id).then (user) ->
            $scope.onSuccess($scope.login_data.selected_company)
  }
]
