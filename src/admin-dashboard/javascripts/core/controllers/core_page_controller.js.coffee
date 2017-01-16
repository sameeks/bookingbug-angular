'use strict';

###*
* @ngdoc controller
* @name BBAdminDashboard.controller:CorePageController
* @description
* Controller for the layout (root state)
###
controller = ($scope, $state, company, $uibModalStack, $rootScope, CompanyStoreService) ->
  'ngInject'

  $scope.company = company
  $scope.bb.company = company
  $scope.user = $rootScope.user

  if localStorage.selectedTimezone
    moment.tz.setDefault(localStorage.selectedTimezone)
  else
    #Set timezone globally per company basis (company contains timezone info)
    moment.tz.setDefault(company.timezone)

  CompanyStoreService.country_code = company.country_code
  CompanyStoreService.currency_code = company.currency_code
  CompanyStoreService.time_zone = company.timezone

  # checks to see if passed in state is part of the active chain
  $scope.isState = (states)->
    return $state.includes states

  $rootScope.$on '$stateChangeStart', () ->
    $uibModalStack.dismissAll()

  return

angular.module('BBAdminDashboard').controller 'CorePageController', controller
