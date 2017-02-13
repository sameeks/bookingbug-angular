angular.module("BB.Directives").directive("bbFbLogin", (LoginService,
    $rootScope, AlertService, $window) =>

  ({
    restrict: 'A',
    scope: true,
    link(scope, element, attrs) {

      let options = scope.$eval(attrs.bbFbLogin) || {};
      $rootScope.connection_started.then(() => checkLoginState());

      let statusChangeCallback = function(response) {
        if (response.status === 'connected') {
          let params = {};
          params.access_token = response.authResponse.accessToken;
          if (options.login_only) { params.login_only = options.login_only; }
          loginToBBWithFBUser(params);
        } else if (response.status === 'not_authorized') {
           scope.loginFB();
        } else {
          scope.loginFB();
        }
      };

      var checkLoginState = function() {
        FB.getLoginStatus(function(response) {
          statusChangeCallback(response);
        });
      };

      var loginToBBWithFBUser = params =>
        LoginService.FBLogin(scope.bb.company, params).then(function(member) {
          $rootScope.member = member;
          scope.setClient($rootScope.member);
          if (scope.bb.destination) {
            return scope.redirectTo(scope.bb.destination);
          } else {
            scope.setLoaded(scope);
            return scope.decideNextPage();
          }
        }
        , function(err) {
          if (err.data.error === "FACEBOOK-LOGIN-MEMBER-NOT-FOUND") {
            return AlertService.raise('FB_LOGIN_NOT_A_MEMBER');
          } else {
            return AlertService.raise('LOGIN_FAILED');
          }
        })
      ;


      return scope.loginFB = () =>
        FB.login((function(response) {
          if (response.status === 'connected') {
            let params = {};
            params.access_token = response.authResponse.accessToken;
            if (options.login_only) { params.login_only = options.login_only; }
            loginToBBWithFBUser(params);
          } else if (response.status === 'not_authorized') {
            AlertService.raise('LOGIN_FAILED');
          } else {
            AlertService.raise('LOGIN_FAILED');
          }
        }), {scope: 'public_profile,email'})
      ;
    }
  })
);

