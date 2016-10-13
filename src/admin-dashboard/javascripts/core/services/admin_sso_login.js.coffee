###*
* @ngdoc service
* @name BBAdminDashboard.AdminSsoLogin
*
* @description
* Responsible for loging in the admin user via the sso token
*
###
angular.module('BBAdminDashboard').factory 'AdminSsoLogin', [
  'halClient', '$q'
  (halClient, $q) ->
    ssoToken: null
    companyId: null
    apiUrl: null
    ssoLoginPromise: (ssoToken = @ssoToken, companyId = @companyId, apiUrl = @apiUrl) ->
      defer = $q.defer()

      # if something is missing reject the promise
      if !ssoToken? || !companyId? || !apiUrl?
        defer.reject()
        return defer.promise

      data = {
        token: ssoToken
      }
      halClient.$post("#{apiUrl}/api/v1/login/admin_sso/#{companyId}", {}, data).then (login) ->
        params = {auth_token: login.auth_token}
        login.$get('administrator', params).then (admin) ->
          defer.resolve(admin)
        , (err) ->
          defer.reject(err)
      , (err) ->
        defer.reject(err)
      defer.promise
]
