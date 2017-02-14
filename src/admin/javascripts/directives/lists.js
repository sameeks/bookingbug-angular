// TODO: This file was created by bulk-decaffeinate.
// Sanity-check the conversion and remove this comment.
angular.module('BBAdmin.Directives').directive('bbPeopleList', $rootScope =>
    ({
        restrict: 'AE',
        replace: true,
        scope: true,
        controller($scope, $rootScope, PersonService, $q, BBModel, PersonModel) {
            $rootScope.connection_started.then(() =>
                $scope.bb.company.$getPeople().then(function (people) {
                    $scope.people = people;
                    return Array.from(people).map((person) =>
                        person.show = true);
                })
            );
            $scope.show_all_people = () =>
                Array.from($scope.people).map((x) =>
                    x.show = true)
            ;
            return $scope.hide_all_people = () =>
                Array.from($scope.people).map((x) =>
                    x.show = false)
                ;
        },
        link(scope, element, attrs) {

        }
    })
);


angular.module('BBAdmin.Directives').directive('bbBookingList', () =>
    ({
        restrict: 'AE',
        replace: true,
        scope: {
            bookings: '=',
            cancelled: '=',
            params: '='
        },

        templateUrl(tElm, tAttrs) {
            return tAttrs.template;
        },

        controller($scope, $filter) {
            $scope.title = $scope.params.title;
            let {status} = $scope.params;

            return $scope.$watch(() => $scope.bookings
                , function () {
                    let {bookings} = $scope;
                    let {cancelled} = $scope;
                    if (cancelled == null) {
                        cancelled = false;
                    }

                    if (bookings != null) {
                        bookings = $filter('filter')(bookings, function (booking) {
                            let ret = (booking.is_cancelled === cancelled);
                            if (status != null) {
                                ret &= booking.hasStatus(status);
                            } else {
                                ret &= ((booking.multi_status == null) || (Object.keys(booking.multi_status).length === 0));
                            }
                            ret &= (booking.status === 4);
                            return ret;
                        });

                        $scope.relevantBookings = $filter('orderBy')(bookings, 'datetime');
                    }

                    return $scope.relevantBookings != null ? $scope.relevantBookings : ($scope.relevantBookings = []);
                });
        }
    }));

