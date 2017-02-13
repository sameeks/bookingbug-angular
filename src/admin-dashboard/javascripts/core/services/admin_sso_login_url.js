// TODO: This file was created by bulk-decaffeinate.
// Sanity-check the conversion and remove this comment.
/**
* @ngdoc service
* @name BBAdminDashboard.AdminSsoLoginUrl
*
* @description
* Returns the complete url for admin sso login
*/
angular.module('BBAdminDashboard').factory('AdminSsoLoginUrl', [
  '$rootScope', 'company_id', '$exceptionHandler',
  function($rootScope, company_id, $exceptionHandler) {
    // Make sure we dont override the company id if its already set
    if ($rootScope.bb.companyId == null) {
      $rootScope.bb.companyId |= company_id;
    }

    if (!$rootScope.bb.companyId) {
      $exceptionHandler(new Error('Angular value "company_id" is undefined! '), '', true);
    }

    return `${$rootScope.bb.api_url}/api/v1/login/admin_sso/${$rootScope.bb.companyId}`;
  }
]);
