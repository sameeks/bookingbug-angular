angular.module('BBMember').directive 'memberSsoLogin', ($rootScope, LoginService, $sniffer, $timeout, QueryStringService) ->
  scope:
    # token: '@memberSsoLogin'
    company_id: '@companyId'
    member: '='
  transclude: true
  template: """
<div ng-if='member' ng-transclude></div>
"""
  link: (scope, element, attrs) ->

    scope.member = null
    options =
      root: $rootScope.bb.api_url
      company_id: scope.companyId
    data = {}
    # data.token = scope.token if scope.token
    data.token ||= QueryStringService('sso_token')

    if $sniffer.msie and $sniffer.msie < 10 and $rootScope.iframe_proxy_ready is false
      $timeout () ->
        LoginService.ssoLogin(options, data).then (member) ->
          scope.member = member
          # TODO?
          # set client?
      , 2000
    else
      LoginService.ssoLogin(options, data).then (member) ->
        scope.member = member
         # TODO?
          # set client?

