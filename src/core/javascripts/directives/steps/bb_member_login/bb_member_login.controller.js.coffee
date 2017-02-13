'use strict'

angular.module('BB.Controllers').controller 'MemberLogin', ($scope, $log, $rootScope, $templateCache, $q, halClient, BBModel, $sessionStorage, $window, AlertService, ValidatorService, LoadingService) ->

  $scope.login = {}

  console.warn('Deprecation warning: validator.validateForm() will be removed from bbMemberLogin in an upcoming major release, please update your template to use bbForm and submitForm() instead. See https://github.com/bookingbug/bookingbug-angular/issues/638')
  $scope.validator = ValidatorService

  loader = LoadingService.$loader($scope).notLoaded()

  $rootScope.connection_started.then () ->

    if BBModel.Login.$checkLogin()
      $scope.setClient($rootScope.member)
      if $scope.bb.destination
        $scope.redirectTo($scope.bb.destination)
      else
        loader.setLoaded()
        $scope.skipThisStep()
        $scope.decideNextPage()
    else
      halClient.$get("#{$scope.bb.api_url}/api/v1").then (root) ->
        root.$get("new_login").then (new_login) ->
          $scope.form = new_login.form
          $scope.schema = new_login.schema
          loader.setLoaded()
        , (err) ->
          console.log 'err ', err
      , (err) ->
        console.log 'err ', err


  $scope.submit = () ->

    $scope.login.role = 'member'

    $scope.bb.company.$post('login', {}, $scope.login).then (login) ->
      if login.$has('members')
        login.$get('members').then (members) ->
          $scope.handleLogin(members[0])
      else if login.$has('member')
        login.$get('member').then (member) ->
          $scope.handleLogin(member)
    , (err) ->
      if err.data.error is "Account has been disabled"
        AlertService.raise('ACCOUNT_DISABLED')
      else
        AlertService.raise('LOGIN_FAILED')


  $scope.handleLogin = (member) ->
    member = BBModel.Login.$setLogin(member, $scope.login.persist_login)
    $scope.setClient(member)
    if $scope.bb.destination
      $scope.redirectTo($scope.bb.destination)
    else
      $scope.skipThisStep()
      $scope.decideNextPage()
