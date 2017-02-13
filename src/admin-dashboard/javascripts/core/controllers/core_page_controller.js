/**
* @ngdoc controller
* @name BBAdminDashboard.controller:CorePageController
* @description
* Controller for the layout (root state)
*/
let controller = function($scope, $state, company, $uibModalStack, $rootScope, GeneralOptions, CompanyStoreService) {
  'ngInject';

  $scope.company = company;
  $scope.bb.company = company;
  $scope.user = $rootScope.user;

  //Set timezone globally per company basis (company contains timezone info)
  moment.tz.setDefault(company.timezone);

  CompanyStoreService.country_code = company.country_code;
  CompanyStoreService.currency_code = company.currency_code;
  CompanyStoreService.time_zone = company.timezone;

  // checks to see if passed in state is part of the active chain
  $scope.isState = states=> $state.includes(states);

  $rootScope.$on('$stateChangeStart', () => $uibModalStack.dismissAll());

};

angular.module('BBAdminDashboard').controller('CorePageController', controller);
