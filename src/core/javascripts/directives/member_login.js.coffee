angular.module('BB').directive 'bbMemberLogin', ($log, $rootScope,
    $templateCache, $q, halClient, BBModel, $sessionStorage, $window, AlertService) ->

  controller = ($scope) ->

    $scope.login_form = {}

    $scope.redirectTo = (destination) ->
      $window.location.href = destination

    $scope.submit = (form) ->
      form['role'] = 'member'
      $scope.company.$post('login', {}, form).then (login) ->
        if login.$has('members')
          login.$get('members').then (members) ->
            $rootScope.member = new BBModel.Member.Member members[0]
            auth_token = $rootScope.member.getOption('auth_token')
            $sessionStorage.setItem("login", $rootScope.member.$toStore())
            $sessionStorage.setItem("auth_token", auth_token)
            $scope.setClient($rootScope.member)
            if $scope.bb.destination
              $scope.redirectTo($scope.bb.destination)
            else
              $scope.decideNextPage()
        else if login.$has('member')
          login.$get('member').then (member) ->
            $rootScope.member = new BBModel.Member.Member member
            auth_token = $rootScope.member.getOption('auth_token')
            $sessionStorage.setItem("login", $rootScope.member.$toStore())
            $sessionStorage.setItem("auth_token", auth_token)
            $scope.setClient($rootScope.member)
            $scope.decideNextPage()
      , (err) ->
        AlertService.danger({msg: "Sorry, your email or password was not recognised. Please try again."})


  link = (scope, element, attrs) ->
    if $sessionStorage.getItem("login")
      session_member = $sessionStorage.getItem("login")
      session_member = halClient.createResource(session_member)
      $rootScope.member = new BBModel.Member.Member session_member
      scope.setClient($rootScope.member)
      if scope.bb.destination
        scope.redirectTo(scope.bb.destination)
      else
        scope.decideNextPage()
    else
      halClient.$get("#{scope.bb.api_url}/api/v1").then (root) ->
        root.$get("new_login").then (new_login) ->
          scope.form = new_login.form
          scope.schema = new_login.schema
        , (err) ->
          console.log 'err ', err
      , (err) ->
        console.log 'err ', err

  {
    restrict: 'A'
    link: link
    template: """
<form name="login_form" ng-submit="submit(login_form)" sf-schema="schema"
  sf-form="form" sf-model="login_form" sf-options="{feedback: false}"
  ng-if="schema && form"></form>
"""
    controller: controller
  }


