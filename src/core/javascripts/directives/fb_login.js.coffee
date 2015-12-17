angular.module("BB.Directives").directive "bbFbLogin", (LoginService, $rootScope, AlertService, $window) ->
  restrict: 'A'
  scope: true
  link: (scope, element, attrs) ->
    
    $rootScope.connection_started.then ->
      checkLoginState()
 
    statusChangeCallback = (response) ->
      if response.status == 'connected'
        params = {}
        params.access_token = response.authResponse.accessToken
        loginToBBWithFBUser(params)
      else if response.status == 'not_authorized'
         scope.loginFB()
      else
        scope.loginFB()
      return

    checkLoginState = () ->
      FB.getLoginStatus (response) ->
        statusChangeCallback response
        return
      return

    loginToBBWithFBUser = (params) ->
      LoginService.FBLogin(scope.bb.company, params).then (member) ->
        $rootScope.member = member
        scope.setClient($rootScope.member)
        if scope.bb.destination
          scope.redirectTo(scope.bb.destination)
        else
          scope.setLoaded scope
          scope.decideNextPage()
      , (err) ->
        AlertService.raise('LOGIN_FAILED')

    redirectTo = (destination) ->
      $window.location.href = destination

    scope.loginFB = () ->
      FB.login ((response) ->
        if response.status == 'connected'
          params = {}
          params.access_token = response.authResponse.accessToken
          loginToBBWithFBUser(params)
        else if response.status == 'not_authorized'
          AlertService.raise('LOGIN_FAILED')
        else
          AlertService.raise('LOGIN_FAILED')
        return
      ), scope: 'public_profile,email'

  
