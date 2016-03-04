angular.module('BBAdminDashboard').directive 'bbFrame', ->
  restrict: 'AE'
  replace: true
  controller: ($scope, $sce) ->
    $scope.frame_src = $sce.trustAsResourceUrl($scope.bb.api_url + '/' + unescape($scope.path) + "?whitelabel=adminlte&uiversion=aphid&#{$scope.extra_params if $scope.extra_params}")
