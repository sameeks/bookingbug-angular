// TODO: This file was created by bulk-decaffeinate.
// Sanity-check the conversion and remove this comment.
angular.module("BB.Services").factory("RecaptchaService", ($q, halClient, UriTemplate) =>

  ({
    validateResponse(params) {
      let deferred = $q.defer();
      let href = params.api_url + "/api/v1/recaptcha";
      let uri = new UriTemplate(href);
      let prms = {};
      prms.response = params.response;
      halClient.$post(uri, {}, prms).then(response => deferred.resolve(response)
      , err => deferred.reject(err));
      return deferred.promise;
    }
  })
);

