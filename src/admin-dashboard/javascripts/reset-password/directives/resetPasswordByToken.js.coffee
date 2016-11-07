'use strict'

###
 * @ngdoc directive
 * @name BBAdminDashboard.reset-password.directive:resetPasswordByToken
 * @scope
 * @restrict A
 *
 * @description
 * Reset password journey directive
 *
 * @param {object}  field   A field object
###
angular.module('BBAdminDashboard.reset-password.directives').directive 'resetPasswordByToken', [() ->
  {
    restrict: 'AE'
    replace: true
    scope: {}
    template: '<div ng-include="reset_password_template"></div>'
    controller: ['$scope', '$rootScope', 'BBModel', '$q', '$localStorage', 'AdminLoginOptions', 'ResetPasswordService', ($scope, $rootScope, BBModel, $q, $localStorage, AdminLoginOptions, ResetPasswordService)->
      # $scope.template_vars =
      #   show_api_field: AdminLoginOptions.show_api_field
      #   show_login: true
      #   show_pick_company: false
      #   show_pick_department: false
      #   show_loading: false

      # $scope.login =
      #   email: null
      #   password: null
      #   selected_admin: null
      #   selected_company: null
      #   site: $localStorage.getItem("api_url")

      $scope.reset_password_template = 'reset-password/reset-password-by-token.html'

      # $scope.login = (isValid) ->
      #   if isValid
      #     $scope.template_vars.show_loading = true

      #     #if the site field is used set the api url to the submmited url
      #     if AdminLoginOptions.show_api_field
      #       if $scope.login.site.indexOf("http") == -1
      #         $scope.login.site = "https://" + $scope.login.site
      #       $scope.bb.api_url = $scope.login.site
      #       $rootScope.bb.api_url = $scope.login.site
      #       $localStorage.setItem("api_url", $scope.login.site)

      #     params =
      #       email: $scope.login.email
      #       password: $scope.login.password
      #     BBModel.Admin.Login.$login(params).then (user) ->
      #       companySelection(user)

      #     , (err) ->
      #       $scope.template_vars.show_loading = false
      #       message = "ADMIN_DASHBOARD.LOGIN_PAGE.ERROR_INCORRECT_CREDS"
      #       $scope.formErrors.push { message: message } if !formErrorExists message

    ]
  }
]
