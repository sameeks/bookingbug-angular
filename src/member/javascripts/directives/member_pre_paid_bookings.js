// TODO: This file was created by bulk-decaffeinate.
// Sanity-check the conversion and remove this comment.
angular.module('BBMember').directive('bbMemberPrePaidBookings', ($rootScope, PaginationService) =>

    ({
        templateUrl: 'member_pre_paid_bookings.html',
        scope: {
            member: '='
        },
        controller: 'MemberBookings',
        link(scope, element, attrs) {

            scope.pagination = PaginationService.initialise({page_size: 10, max_size: 5});

            let getBookings = () =>
                    scope.getPrePaidBookings({}).then(pre_paid_bookings => PaginationService.update(scope.pagination, pre_paid_bookings.length))
                ;


            scope.$watch('member', function () {
                if (!scope.pre_paid_bookings) {
                    return getBookings();
                }
            });


            scope.$on("booking:cancelled", event =>
                scope.getPrePaidBookings({}).then(pre_paid_bookings => PaginationService.update(scope.pagination, pre_paid_bookings.length))
            );


            if (scope.member) {
                return getBookings();
            }
        }
    })
);
