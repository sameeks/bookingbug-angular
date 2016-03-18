angular.module('BBAdminDashboard').controller 'bbAdminConfigPageController', ($scope, $sce, $state, $rootScope, $window) ->

    $scope.parent_state = $state.is("config")
    $scope.path = "edit"

    $rootScope.$on '$stateChangeStart', (event, toState, toParams, fromState, fromParams) ->
      $scope.parent_state = false
      if (toState.name == "config")
        $scope.parent_state = true

