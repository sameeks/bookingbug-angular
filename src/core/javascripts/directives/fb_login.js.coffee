angular.module("BB.Directives").directive "bbFbLogin", (LoginService) ->
  restrict: 'A'
  scope: true
  link: (scope, element, attrs) ->
    scope.loginRequired = false

    checkLoginState()
 
    statusChangeCallback = (response) ->
      console.log 'statusChangeCallback'
      console.log response
      if response.status == 'connected'
        # Logged into your app and Facebook.
        fb_user = getFBUser()
        console.log("Logged into Facebook and BB FB App")
        console.log("Now need to call BB API and Login / CREATE member and Login then store the secret access Token")
        LoginService.FBLogin(fb_user).then (member) ->
          scope.member = member
          # if $scope.bb.destination
          #   $scope.redirectTo($scope.bb.destination)
          # else
          #   $scope.setLoaded $scope
          #   $scope.decideNextPage()
        , (err) ->
          console.log(err)
      else if response.status == 'not_authorized'
        # The person is logged into Facebook, but not your app.
         console.log("Please login into BookingBug FB APP")
         scope.loginRequired = true
      else
        # The person is not logged into Facebook
        console.log("Please login into FB")
        scope.loginRequired = true
      return

    checkLoginState = () ->
      console.log("checkLoginState")
      FB.getLoginStatus (response) ->
        statusChangeCallback response
        return
      return

    scope.loginFB = () ->
      console.log("loginFB")
      FB.login ((response) ->
        console.log(response)
        if response.status == 'connected'
          console.log("Logged into Facebook and BB FB App")
          console.log("Now need to call BB API and Login / CREATE member and Login then store the secret access Token")
          fb_user = getFBUser()
          LoginService.FBLogin(fb_user).then (member) ->
            scope.member = member
            # if $scope.bb.destination
            #   $scope.redirectTo($scope.bb.destination)
            # else
            #   $scope.setLoaded $scope
            #   $scope.decideNextPage()
          , (err) ->
            console.log(err)
        else if response.status == 'not_authorized'
          # The person is logged into Facebook, but not your app.
        else
          # The person is not logged into Facebook
        return
      ), scope: 'public_profile,email'

    getFBUser = ->
      FB.api '/me', (response) ->
        return response
  
