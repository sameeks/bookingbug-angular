/*
* @ngdoc service
* @name BBAdminDashboard.reset-password.service:ResetPasswordSchemaFormService
*
* @description
* This service enables the user to fetch/submit a schema form from/to the server and also post the new password.
*/

let ResetPasswordSchemaFormService = function($q, $http, QueryStringService) {
  'ngInject';

  let passwordPattern = '';

  let setPasswordPattern = function(pattern) {
    let password_pattern;
    return password_pattern = pattern;
  };

  let getPasswordPattern = () => passwordPattern;

  let getSchemaForm = function(baseUrl) {
    let deferred = $q.defer();
    let src = baseUrl + "/api/v1/login/admin/reset_password_schema";

    $http.get(src, {}).then(response => deferred.resolve(response)
    , err => deferred.reject(err));
    return deferred.promise;
  };

  let postSchemaForm = function(password, baseUrl) {
    let deferred = $q.defer();
    let src = baseUrl + "/api/v1/login/admin/reset_password";

    let resetPasswordToken = QueryStringService('reset_password_token');

    let body = {"password": password, "reset_password_token": resetPasswordToken};

    $http.put(src, body).then(response => deferred.resolve(response)
    , err => deferred.reject(err));
    return deferred.promise;
  };

  return {
    setPasswordPattern,
    getPasswordPattern,
    getSchemaForm,
    postSchemaForm
  };
};

angular
  .module('BBAdminDashboard.reset-password')
  .factory('ResetPasswordSchemaFormService', ResetPasswordSchemaFormService);
