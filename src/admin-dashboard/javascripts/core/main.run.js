// TODO: This file was created by bulk-decaffeinate.
// Sanity-check the conversion and remove this comment.
angular.module('BBAdminDashboard').run(function(RuntimeStates, AdminCoreOptions, RuntimeRoutes, AdminLoginService) {
  'ngInject';

  RuntimeRoutes.otherwise('/');

  RuntimeStates
  .state('root', {
    url: '/',
    templateUrl: "core/layout.html",
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
            , err => defer.reject({reason: 'NOT_LOGGABLE_ERROR'}));
          }
        }
        , err => defer.reject({reason: 'LOGIN_SERVICE_ERROR', error: err}));
        return defer.promise;
      },

      company(user, $q, BBModel) {
        let defer = $q.defer();
        user.$getCompany().then(function(company) {
          if (company.companies && (company.companies.length > 0)) {
            return defer.reject({reason: 'COMPANY_IS_PARENT'});
          } else {
            return defer.resolve(company);
          }
        }
        , err =>
          BBModel.Admin.Login.$logout().then(()=> defer.reject({reason: 'GET_COMPANY_ERROR'})
          , err=> defer.reject({reason: 'LOGOUT_ERROR'}))
        );
        return defer.promise;
      }
    },

    controller: 'CorePageController',
    deepStateRedirect: {
      default: {
        state: AdminCoreOptions.default_state
      }
    }
  });

});