###**
* @ngdoc service
* @name BB:AdminSsoLoginUrl
*
* @description
* Returns the complete url for admin sso login
###
angular.module('BB').factory 'AdminSsoLoginUrl', [
  '$rootScope', 'company_id', '$exceptionHandler',
  ($rootScope, company_id, $exceptionHandler) ->
    # Make sure we dont override the company id if its already set
    if not $rootScope.bb.companyId?
      $rootScope.bb.companyId |= company_id

    if not $rootScope.bb.companyId 
      $exceptionHandler(new Error('Angular value "company_id" is undefined! '))
        
    "#{$rootScope.bb.api_url}/api/v1/login/admin_sso/#{$rootScope.bb.companyId}"
]

###**
* @ngdoc service
* @name BB:AdminSsoLogin
*
* @description
* Responsible for loging in the admin user via the sso token
*
* @property {string} sso_token The sso_token to be used
* @property {function} callback (optional) funtion to be called after the successfull login, receives UserAdmin (BaseResource) obj as input 
###
angular.module('BB').factory 'AdminSsoLogin', [
  'halClient', 'AdminSsoLoginUrl',
  (halClient, AdminSsoLoginUrl) ->
    return (sso_token, callback)->
      data = {
        token: sso_token
      }
      halClient.$post(AdminSsoLoginUrl, {}, data).then (login) ->
        params = {auth_token: login.auth_token}
        login.$get('administrator', params).then (admin) ->
          if typeof callback == 'function'
            callback admin
]