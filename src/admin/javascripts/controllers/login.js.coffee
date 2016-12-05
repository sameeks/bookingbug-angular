'use strict'

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
  $rootScope, $q, $sessionStorage, BBModel) ->

  $scope.login_form =
    host: $sessionStorage.getItem('host')
    email: null
    password: null
    selected_admin: null

  $scope.login_template = 'login/admin_login.html'

  $scope.login = () ->
    $scope.alert = ""
    params =
      email: $scope.login_form.email
      password: $scope.login_form.password
    BBModel.Admin.Login.$login(params).then (user) ->
      if user.company_id?
        $scope.user = user
        $scope.onSuccess() if $scope.onSuccess
      else
        user.$getAdministrators().then (administrators) ->
          $scope.administrators = administrators
          $scope.pickCompany()
    , (err) ->
      $scope.alert = "Sorry, either your email or password was incorrect"

  $scope.pickCompany = () ->
    $scope.login_template = 'login/admin_pick_company.html'

  $scope.selectedCompany = () ->
    $scope.alert = ""
    params =
      email: $scope.login_form.email
      password: $scope.login_form.password
    $scope.login_form.selected_admin.$post('login', {}, params).then (login) ->
      $scope.login_form.selected_admin.$getCompany().then (company) ->
        $scope.bb.company = company
        BBModel.Admin.Login.$setLogin($scope.login_form.selected_admin)
        $scope.onSuccess(company)

