'use strict';

###
* @ngdoc controller
* @name BBAdminDashboard.controllers.controller:CorePageController
#
* @description
* Controller for the layout (root state)
###
angular.module('BBAdminDashboard.controllers')
.controller 'CorePageController',['$scope', '$state', 'company', 'SideNavigationPartials', ($scope, $state, company, SideNavigationPartials) ->
  $scope.company = company
  $scope.bb.company = company
  #Set timezone globally per company basis (company contains timezone info)
  moment.tz.setDefault(company.timezone)

  # checks to see if passed in state is part of the active chain
  $scope.isState = (states)->
    return $state.includes states

]