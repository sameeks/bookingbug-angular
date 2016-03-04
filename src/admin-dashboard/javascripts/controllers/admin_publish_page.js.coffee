angular.module('BBAdminDashboard').controller 'bbAdminPublishPageController', ($scope, $sce, $state, $rootScope, $window) ->

    $scope.parent_state = $state.is("publish")
    $scope.path = "conf"

    $rootScope.$on '$stateChangeStart', (event, toState, toParams, fromState, fromParams) ->
      $scope.parent_state = false
      if (toState.name == "setting")
        $scope.parent_state = true

