angular.module('BBAdminDashboard').controller 'bbAdminRootPageController', ($scope,
      user, company) ->

  $scope.company = company
  $scope.bb.company = company
  #Set timezone globally per company basis (company contains timezone info)
  moment.tz.setDefault(company.timezone)
