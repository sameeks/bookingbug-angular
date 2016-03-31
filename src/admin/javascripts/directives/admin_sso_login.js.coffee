angular.module('BBAdmin.Directives').directive 'bbAdminSsoLogin', (AdminLoginService, QueryStringService, halClient) ->

  link = (scope, element, attrs) ->
    scope.qs = QueryStringService
    data = {}
    data.token = scope.token if scope.token
    data.token ||= scope.qs('sso_token') if scope.qs
    url = "#{scope.apiUrl}/api/v1/login/admin_sso/#{scope.companyId}"
    halClient.$post(url, {}, data).then (login) ->
      params = {auth_token: login.auth_token}
      login.$get('administrator', params).then (admin) ->
        scope.admin = admin
        AdminLoginService.setLogin(admin)

  link: link
  scope:
    token: '@bbAdminSsoLogin'
    companyId: '='
    apiUrl: '='
  transclude: true
  template: """
<div ng-if='admin' ng-transclude></div>
"""
