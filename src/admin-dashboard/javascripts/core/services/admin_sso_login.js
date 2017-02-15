// TODO: This file was created by bulk-decaffeinate.
// Sanity-check the conversion and remove this comment.
/**
 * @ngdoc service
 * @name BBAdminDashboard.AdminSsoLogin
 *
 * @description
 * Responsible for loging in the admin user via the sso token
 *
 */
angular.module('BBAdminDashboard').factory('AdminSsoLogin', (halClient, $q) => {
        return {
            ssoToken: null,
            companyId: null,
            apiUrl: null,
            ssoLoginPromise(ssoToken, companyId, apiUrl) {
                if (ssoToken == null) {
                    ({ssoToken} = this);
                }
                if (companyId == null) {
                    ({companyId} = this);
                }
                if (apiUrl == null) {
                    ({apiUrl} = this);
                }
                let defer = $q.defer();

                // if something is missing reject the promise
                if ((ssoToken == null) || (companyId == null) || (apiUrl == null)) {
                    defer.reject();
                    return defer.promise;
                }

                let data = {
                    token: ssoToken
                };
                halClient.$post(`${apiUrl}/api/v1/login/admin_sso/${companyId}`, {}, data).then(function (login) {
                        let params = {auth_token: login.auth_token};
                        return login.$get('administrator', params).then(admin => defer.resolve(admin)
                            , err => defer.reject(err));
                    }
                    , err => defer.reject(err));
                return defer.promise;
            }
        };
    }
);
