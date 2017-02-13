angular.module('BBMember').directive('bbMemberPurchases', ($rootScope, PaginationService) =>

  ({
    templateUrl: 'member_purchases.html',
    scope: true,
    controller: 'MemberPurchases',
    link(scope, element, attrs) {

      scope.member = scope.$eval(attrs.member);
      if ($rootScope.member) { if (!scope.member) { scope.member = $rootScope.member; } }

      scope.pagination = PaginationService.initialise({page_size: 10, max_size: 5});

      return $rootScope.connection_started.then(function() {
        if (scope.member) {
          return scope.getPurchases().then(purchases => PaginationService.update(scope.pagination, purchases.length));
        }
      });
    }
  })
);
