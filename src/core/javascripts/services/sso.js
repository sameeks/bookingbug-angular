// TODO: This file was created by bulk-decaffeinate.
// Sanity-check the conversion and remove this comment.
angular.module('BB.Services').factory("SSOService", ($q, $rootScope, halClient, LoginService) =>

  ({
    memberLogin(options) {
      let deferred = $q.defer();
      if (!options.root) { options.root = ""; }
      let url = options.root + "/api/v1/login/sso/" + options.company_id;
      let data = {token: options.member_sso};
      halClient.$post(url, {}, data).then(login => {
        let params = {auth_token: login.auth_token};
        return login.$get('member').then(member => {
          member = LoginService.setLogin(member);
          return deferred.resolve(member);
        }
        );
      }
      , err => {
        return deferred.reject(err);
      }
      );
      return deferred.promise;
    },

    adminLogin(options) {
      let deferred = $q.defer();
      if (!options.root) { options.root = ""; }
      let url = options.root + "/api/v1/login/admin_sso/" + options.company_id;
      let data = {token: options.admin_sso};
      halClient.$post(url, {}, data).then(login => {
        let params = {auth_token: login.auth_token};
        return login.$get('administrator').then(admin => {
          return deferred.resolve(admin);
        }
        );
      }
      , err => {
        return deferred.reject(err);
      }
      );
      return deferred.promise;
    }
  })
);

