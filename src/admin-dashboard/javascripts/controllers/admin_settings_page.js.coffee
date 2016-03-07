angular.module('BBAdminDashboard').controller 'bbAdminSettingsPageController', ($scope, $sce, $state, $rootScope, $window) ->

    $scope.parent_state = $state.is("setting")
    $scope.path = "conf"

    $rootScope.$on '$stateChangeStart', (event, toState, toParams, fromState, fromParams) ->
      $scope.parent_state = false
      if (toState.name == "setting")
        $scope.parent_state = true

