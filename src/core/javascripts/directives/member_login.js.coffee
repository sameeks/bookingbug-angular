angular.module('BB').directive 'bbMemberLogin', ($log, $rootScope, $templateCache, $q, halClient, BBModel, $sessionStorage, $window, AlertService, LoginService) ->
  restrict: 'A'
  template: """
<form name="login_form" ng-submit="submit(login_form)" sf-schema="schema"
sf-form="form" sf-model="login_form" sf-options="{feedback: false}"
ng-if="schema && form"></form>
"""
  controller: ($scope, $element, $attrs) ->

    $scope.login_form = {}

    $rootScope.connection_started.then () ->

      if $sessionStorage.getItem("login")
        session_member = $sessionStorage.getItem("login")
        session_member = halClient.createResource(session_member)
        $rootScope.member = new BBModel.Member.Member session_member
        $scope.setClient($rootScope.member)
        if $scope.bb.destination
          $scope.redirectTo($scope.bb.destination)
        else
          $scope.setLoaded $scope
          $scope.decideNextPage()
      else
        halClient.$get("#{$scope.bb.api_url}/api/v1").then (root) ->
          root.$get("new_login").then (new_login) ->
            $scope.form = new_login.form
            $scope.schema = new_login.schema
          , (err) ->
            console.log 'err ', err
        , (err) ->
          console.log 'err ', err


    $scope.submit = (form) ->

      form['role'] = 'member'

      $scope.company.$post('login', {}, form).then (login) ->
        if login.$has('members')
          login.$get('members').then (members) ->
            handleLogin(members[0])
        else if login.$has('member')
          login.$get('member').then (member) ->
            handleLogin(member)
      , (err) ->
        if err.data.error == "Account has been disabled"
          AlertService.raise('ACCOUNT_DISABLED')
        else
          AlertService.raise('LOGIN_FAILED')


    handleLogin = (member) ->
      member = LoginService.setLogin(member)
      $scope.setClient(member)
      if $scope.bb.destination
        $scope.redirectTo($scope.bb.destination)
      else
        $scope.skipThisStep()
        $scope.decideNextPage()