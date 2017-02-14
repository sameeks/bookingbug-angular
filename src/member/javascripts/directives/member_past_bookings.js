// TODO: This file was created by bulk-decaffeinate.
// Sanity-check the conversion and remove this comment.
angular.module('BBMember').directive('bbMemberPastBookings', ($rootScope, PaginationService) =>

    ({
        templateUrl: 'member_past_bookings.html',
        scope: {
            member: '=',
            notLoaded: '=',
            setLoaded: '='
        },
        controller: 'MemberBookings',
        link(scope, element, attrs) {

            scope.pagination = PaginationService.initialise({page_size: 10, max_size: 5});

            let getBookings = () =>
                    scope.getPastBookings().then(function (past_bookings) {
                        if (past_bookings) {
                            return PaginationService.update(scope.pagination, past_bookings.length);
                        }
                    })
                ;


            scope.$watch('member', function () {
                if (scope.member && !scope.past_bookings) {
                    return getBookings();
                }
            });


            if (scope.member) {
                return getBookings();
            }
        }
    })
);
