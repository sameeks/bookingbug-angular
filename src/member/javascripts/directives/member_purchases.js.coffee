angular.module('BBMember').directive 'bbMemberPurchases', ($rootScope) ->
  templateUrl: 'member_purchases.html'
  scope:
    apiUrl: '@'
    member: '='
  controller: 'MemberPurchases'
  link: (scope, element, attrs) ->

    $rootScope.bb ||= {}
    $rootScope.bb.api_url ||= scope.apiUrl
    $rootScope.bb.api_url ||= "http://www.bookingbug.com"

    getPurchases = () ->
      scope.getPurchases()

    scope.$watch 'member', () ->
      getPurchases()