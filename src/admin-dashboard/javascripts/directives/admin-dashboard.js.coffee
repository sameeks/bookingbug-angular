angular.module('BBAdminDashboard').directive 'bbAdminDashboard', () ->
  
  controller = ($scope, $rootScope, $element, $window, $compile, $localStorage,
      AdminLoginService, $state, AlertService) ->

    api_url = $localStorage.getItem("api_url")
    if !$scope.bb.api_url && api_url
      $scope.bb.api_url = api_url

    $rootScope.bb = $scope.bb

    $compile("<span bb-display-mode></span>") $scope, (cloned, scope) =>
      $($element).append(cloned)

    $scope.$on '$stateChangeStart', (event, toState, toParams, fromState, fromParams) ->
      AlertService.clear()
      $scope.adminlte.fixed_page =
        (toParams.path && (toParams.path == "view/dashboard/index" || toParams.path == "view%2Fdashboard%2Findex"))
      $scope.isLoading = true
      if toState.redirectTo
        event.preventDefault()
        $state.go(toState.redirectTo, toParams)

    $scope.$on '$stateChangeSuccess', (event, toState, toParams, fromState, fromParams) ->
      $scope.isLoading = false

    $scope.$on '$stateChangeError', (event, toState, toParams, fromState, fromParams, error) ->
      $scope.isLoading = false

    $scope.$on '$stateChangeNotFound', (event, toState, toParams, fromState, fromParams) ->
      $scope.isLoading = false

    $scope.logout = () ->
      $scope.isLoading = true
      AdminLoginService.logout()

    $scope.closeAlert = (alert) ->
      AlertService.closeAlert(alert)

  restrict: 'AE'
  controller: controller
  templateUrl: 'admin_dashboard.html'

