// TODO: This file was created by bulk-decaffeinate.
// Sanity-check the conversion and remove this comment.
/*
 * @ngdoc service
 * @name BBAdminDashboard.reset-password.service:ResetPasswordService
 *
 * @description
 * This service enables the user to send a request to reset he's password
 */

let ResetPasswordService = function ($q, $window, $http) {
    'ngInject';

    let postRequest = function (email, baseUrl) {
        let deferred = $q.defer();

        let url = baseUrl + "/api/v1/login/admin/reset_password_email";

        let path = $window.location.pathname + '#/reset-password';

        let body = {"email": email, "path": path};

        $http.post(url, body).then(response => deferred.resolve(response)
            , err => deferred.reject(err));
        return deferred.promise;
    };

    return {
        postRequest
    };
};

angular
    .module('BBAdminDashboard.reset-password')
    .factory('ResetPasswordService', ResetPasswordService);
