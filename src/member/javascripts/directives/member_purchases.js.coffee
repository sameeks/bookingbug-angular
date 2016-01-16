angular.module('BBMember').directive 'bbMemberPurchases', ($rootScope, PaginationService) ->
  templateUrl: 'member_purchases.html'
  scope: true
  controller: 'MemberPurchases'
  link: (scope, element, attrs) ->

    scope.member = scope.$eval(attrs.member)
    scope.member ||= $rootScope.member if $rootScope.member

    scope.pagination = PaginationService.initialise({page_size: 10, max_size: 5})

    $rootScope.connection_started.then () ->
      if scope.member
        scope.getPurchases().then (purchases) ->
          PaginationService.update(scope.pagination, purchases.length)