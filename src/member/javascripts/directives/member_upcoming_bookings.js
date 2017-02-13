// TODO: This file was created by bulk-decaffeinate.
// Sanity-check the conversion and remove this comment.
angular.module('BBMember').directive('bbMemberUpcomingBookings', ($rootScope, PaginationService, PurchaseService) =>

  ({
    templateUrl: 'member_upcoming_bookings.html',
    scope: {
      member: '=',
      notLoaded: '=',
      setLoaded: '='
    },
    controller: 'MemberBookings',
    link(scope, element, attrs) {

      scope.pagination = PaginationService.initialise({page_size: 10, max_size: 5});

      let getBookings = () =>
        scope.getUpcomingBookings().then(upcoming_bookings => PaginationService.update(scope.pagination, upcoming_bookings.length))
      ;


      scope.$on('updateBookings', function() {
        scope.flushBookings();
        return getBookings();
      });


      scope.$watch('member', function() {
        if (!scope.upcoming_bookings) { return getBookings(); }
      });


      return $rootScope.connection_started.then(() => getBookings());
    }
  })
);
