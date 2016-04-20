angular.module('BBAdmin.Directives').directive 'bbAdminSsoLogin', ($rootScope, AdminLoginService, QueryStringService, halClient) ->
  restrict: 'EA'
  scope:
    token: '@bbAdminSsoLogin'
    companyId: '@'
    apiUrl: '@'
  transclude: true
  template: """
<div ng-if='admin' ng-transclude></div>
"""

  link: (scope, element, attrs) ->
    scope.qs = QueryStringService
    data = {}
    data.token = scope.qs('sso_token') if scope.qs
    data.token ||= scope.token if scope.token
    api_host = scope.apiUrl if scope.apiUrl
    api_host ||= $rootScope.bb.api_url
    url = "#{api_host}/api/v1/login/admin_sso/#{scope.companyId}"
    halClient.$post(url, {}, data).then (login) ->
      params = {auth_token: login.auth_token}
      login.$get('administrator', params).then (admin) ->
        scope.admin = admin
        AdminLoginService.setLogin(admin)

