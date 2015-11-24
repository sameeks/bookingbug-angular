angular.module('BBMember').directive 'bbMemberPurchases', ($rootScope, PaginationService) ->
  templateUrl: 'member_purchases.html'
  scope:
    apiUrl: '@'
    member: '='
  controller: 'MemberPurchases'
  link: (scope, element, attrs) ->

    $rootScope.bb ||= {}
    $rootScope.bb.api_url ||= scope.apiUrl
    $rootScope.bb.api_url ||= "http://www.bookingbug.com"

    scope.pagination = PaginationService.initialise({page_size: 10, max_size: 5})

    getPurchases = () ->
      scope.getPurchases().then (purchases) ->
        PaginationService.update(scope.pagination, purchases.length)

    scope.$watch 'member', () ->
      getPurchases()