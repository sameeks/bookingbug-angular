'use strict';

###*
* @ngdoc controller
* @name BBAdminDashboard.controller:CorePageController
* @description
* Controller for the layout (root state)
###
controller = ($scope, $state, company, $uibModalStack, $rootScope, SettingsService) ->
  'ngInject'

  $scope.company = company
  $scope.bb.company = company
  $scope.user = $rootScope.user

  #Set timezone globally per company basis (company contains timezone info)
  moment.tz.setDefault(company.timezone)

  SettingsService.setCountryCode(company.country_code)
  SettingsService.setCurrency(company.currency_code)
  SettingsService.setTimeZone(company.timezone)


  # checks to see if passed in state is part of the active chain
  $scope.isState = (states)->
    return $state.includes states

  $rootScope.$on '$stateChangeStart', () ->
    $uibModalStack.dismissAll()

  return

angular.module('BBAdminDashboard').controller 'CorePageController', controller
