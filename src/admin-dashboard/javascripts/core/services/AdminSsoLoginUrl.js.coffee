'use strict'

###**
* @ngdoc service
* @name BBAdminDashboard.services.service:AdminSsoLoginUrl
*
* @description
* Returns the complete url for admin sso login
###
angular.module('BBAdminDashboard.services').factory 'AdminSsoLoginUrl', (
  $rootScope, company_id, $exceptionHandler) ->

    # Make sure we dont override the company id if its already set
    if not $rootScope.bb.companyId?
      $rootScope.bb.companyId |= company_id

    if not $rootScope.bb.companyId
      $exceptionHandler(new Error('Angular value "company_id" is undefined! '), '', true)

    "#{$rootScope.bb.api_url}/api/v1/login/admin_sso/#{$rootScope.bb.companyId}"

