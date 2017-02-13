// TODO: This file was created by bulk-decaffeinate.
// Sanity-check the conversion and remove this comment.
angular.module('BBAdminDashboard.login').run(function(RuntimeStates, AdminLoginOptions) {
  'ngInject';

  // Choose to opt out of the default routing
  if (AdminLoginOptions.use_default_states) {
    RuntimeStates
    .state('login', {
      url: "/login",
      resolve: {
        user($q, BBModel, AdminSsoLogin) {
          let defer = $q.defer();
          BBModel.Admin.Login.$user().then(function(user) {
            if (user) {
              return defer.resolve(user);
            } else {
              return AdminSsoLogin.ssoLoginPromise().then(function(admin){
                BBModel.Admin.Login.$setLogin(admin);
                return BBModel.Admin.Login.$user().then(user => defer.resolve(user)
                , err => defer.reject({reason: 'GET_USER_ERROR', error: err}));
              }
              , err => defer.resolve());
            }
          }
          , err => defer.reject({reason: 'LOGIN_SERVICE_ERROR', error: err}));
          return defer.promise;
        }
      },
      controller: "LoginPageCtrl",
      templateUrl: "login/index.html"
    }
    );
  }

});