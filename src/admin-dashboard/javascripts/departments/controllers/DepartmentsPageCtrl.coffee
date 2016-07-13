'use strict'

###
* @ngdoc controller
* @name BBAdminDashboard.departments.controllers.controller:DepartmentsPageCtrl
#
* @description
* Controller for the departments page
###
angular.module('BBAdminDashboard.departments.controllers')
.controller 'DepartmentsPageCtrl', ($scope, company, departments,
  AdminLoginService, $state, $timeout) ->

  $scope.company = company
  $scope.departments = departments

  $scope.selectDepartment = (department) ->
    AdminLoginService.setCompany(department.id).then (user) ->
      $timeout () ->
        $state.go 'calendar', {}, {reload: true}

