
angular.module('BBAdmin.Directives').directive 'bbAdminLogin', () ->

  restrict: 'AE'
  replace: true
  scope: {
    onSuccess: '='
    onCancel: '='
    onError: '='
    bb: '='
  }
  controller: 'AdminLogin'
  template: '<div ng-include="login_template"></div>'


angular.module('BBAdmin.Controllers').controller 'AdminLogin', ($scope,
    $rootScope, AdminLoginService, $q, $sessionStorage) ->

  $scope.login =
    host: $sessionStorage.getItem('host')
    email: null
    password: null
    selected_admin: null

  console.log "test"
  $scope.login_template = 'login/admin_login.html'

  $scope.login = () ->
    $scope.alert = ""
    params =
      email: $scope.login.email
      password: $scope.login.password
    AdminLoginService.login(params).then (user) ->
      if user.company_id?
        $scope.user = user
        $scope.onSuccess() if $scope.onSuccess
      else
        user.getAdministratorsPromise().then (administrators) ->
          $scope.administrators = administrators
          $scope.pickCompany()
    , (err) ->
      $scope.alert = "Sorry, either your email or password was incorrect"

  $scope.pickCompany = () ->
    $scope.login_template = 'admin_pick_company.html'

  $scope.selectedCompany = () ->
    $scope.alert = ""
    params =
      email: $scope.login.email
      password: $scope.login.password
    $scope.login.selected_admin.$post('login', {}, params).then (login) ->
      $scope.login.selected_admin.getCompanyPromise().then (company) ->
        $scope.bb.company = company
        AdminLoginService.setLogin($scope.login.selected_admin)
        $scope.onSuccess(company)

