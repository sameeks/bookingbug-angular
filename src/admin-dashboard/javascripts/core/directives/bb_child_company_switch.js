'use strict'

###*
 * @ngdoc directive
 * @name BBAdminDashboard.directive:bbChildCompanySwitch
 * @scope
 * @restrict A
 *
 * @description
 * Functionality that allows you to switch between child companies
 *
###

angular.module('BBAdminDashboard').directive 'bbChildCompanySwitch', () ->
  restrict: 'A'
  replace: true
  scope: true
  controller: ($scope, $state, AdminLoginService) ->

    $scope.logoutChildCompany = () ->
      # fetch the id of the parent of the currently logged in child company.
      $scope.bb.company.$getParent().then (parent_company) ->
        # set the current company to be the parent.
        AdminLoginService.setCompany(parent_company.id).then (response) ->
          $state.go 'login'
        , (err)->
          $scope.formErrors.push { message: "ADMIN_DASHBOARD.LOGIN_PAGE.ERROR_ISSUE_WITH_COMPANY"}
      , (err)->
        $scope.formErrors.push { message: "ADMIN_DASHBOARD.LOGIN_PAGE.ERROR_ISSUE_WITH_COMPANY"}
