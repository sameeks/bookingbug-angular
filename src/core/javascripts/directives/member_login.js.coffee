angular.module('BB').directive 'bbMemberLogin', ($log, $rootScope, $templateCache, $q, halClient, BBModel, $sessionStorage, $window, AlertService, LoginService, PathSvc, ValidatorService) ->
  restrict: 'A'
  templateUrl : (element, attrs) ->
    if attrs.bbCustomLoginForm?
      PathSvc.directivePartial "_member_login_form"
    else
      PathSvc.directivePartial "_member_login_schema_form"

  controller: ($scope, $element, $attrs) ->

    $scope.login_form = {}

    $scope.validator = ValidatorService

    $rootScope.connection_started.then () ->

      if LoginService.checkLogin()
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
        if err.data.error is "Account has been disabled"
          AlertService.raise('ACCOUNT_DISABLED')
        else
          AlertService.raise('LOGIN_FAILED')


    handleLogin = (member) ->
      member = LoginService.setLogin(member, $scope.login_form.persist_login)
      $scope.setClient(member)
      if $scope.bb.destination
        $scope.redirectTo($scope.bb.destination)
      else
        $scope.skipThisStep()
        $scope.decideNextPage()
