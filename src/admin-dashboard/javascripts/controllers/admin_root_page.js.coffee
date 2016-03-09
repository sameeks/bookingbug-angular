angular.module('BBAdminDashboard').controller 'bbAdminRootPageController', ($scope,
      user, company) ->

  $scope.company = company
  $scope.bb.company = company

