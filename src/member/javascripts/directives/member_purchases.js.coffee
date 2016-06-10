angular.module('BBMember').directive 'bbMemberPurchases', ($rootScope, BBModel) ->
  templateUrl: 'member_purchases.html'
  scope: true
  controller: 'MemberPurchases'
  link: (scope, element, attrs) ->

    scope.member = scope.$eval(attrs.member)
    scope.member ||= $rootScope.member if $rootScope.member

    scope.pagination = BBModel.Pagination({page_size: 10, max_size: 5, request_page_size: 100})

    $rootScope.connection_started.then () ->
      if scope.member
        scope.getPurchases().then (purchases) ->
          scope.pagination.num_items = purchases.length
          scope.pagination.update()
