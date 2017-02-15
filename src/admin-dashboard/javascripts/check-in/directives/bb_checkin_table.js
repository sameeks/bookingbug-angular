// TODO: This file was created by bulk-decaffeinate.
// Sanity-check the conversion and remove this comment.
angular.module('BBAdminDashboard.check-in.directives').directive('bbCheckinTable', () => {
        return {
            restrict: 'AE',
            replace: false,
            scope: true,
            templateUrl: 'check-in/checkin-table.html',
            controller: 'CheckinsController',
            link(scope, element, attrs) {

            }
        };
    }
);

angular.module('BBAdminDashboard.check-in.directives').controller('CheckinsController', function ($scope, $rootScope, BusyService, $q, $filter, AdminTimeService, ModalForm,
                                                                                                  AdminSlotService, $timeout, AlertService, BBModel) {

    $scope.$on('refetchCheckin', (event, res) => $scope.getAppointments(null, null, null, null, null, true));


    $scope.getAppointments = function (currentPage, filterBy, filterByFields, orderBy, orderByReverse, skipCache) {
        if (skipCache == null) {
            skipCache = true;
        }
        if (filterByFields && (filterByFields.name != null)) {
            filterByFields.name = filterByFields.name.replace(/\s/g, '');
        }
        if (filterByFields && (filterByFields.mobile != null)) {
            let {mobile} = filterByFields;
            if (mobile.indexOf('0') === 0) {
                filterByFields.mobile = mobile.substring(1);
            }
        }
        let defer = $q.defer();
        let params = {
            company: $scope.company,
            date: moment().format('YYYY-MM-DD'),
            url: $scope.bb.api_url
        };

        if (skipCache) {
            params.skip_cache = true;
        }
        if (filterBy) {
            params.filter_by = filterBy;
        }
        if (filterByFields) {
            params.filter_by_fields = filterByFields;
        }
        if (orderBy) {
            params.order_by = orderBy;
        }
        if (orderByReverse) {
            params.order_by_reverse = orderByReverse;
        }

        BBModel.Admin.Booking.$query(params).then(res => {
                $scope.booking_collection = res;
                $scope.bookings = [];
                $scope.bmap = {};
                for (var item of Array.from(res.items)) {
                    if (item.status !== 3) { // not blocked
                        $scope.bookings.push(item.id);
                        $scope.bmap[item.id] = item;
                    }
                }
                // update the items if they've changed
                $scope.booking_collection.addCallback($scope, (booking, status) => {
                        $scope.bookings = [];
                        $scope.bmap = {};
                        return (() => {
                            let result = [];
                            for (item of Array.from($scope.booking_collection.items)) {
                                let item1;
                                if (item.status !== 3) { // not blocked
                                    $scope.bookings.push(item.id);
                                    item1 = $scope.bmap[item.id] = item;
                                }
                                result.push(item1);
                            }
                            return result;
                        })();
                    }
                );
                return defer.resolve($scope.bookings);
            }
            , err => defer.reject(err));
        return defer.promise;
    };

    $scope.setStatus = (booking, status) => {
        let clone = _.clone(booking);
        clone.current_multi_status = status;
        return booking.$update(clone).then(res => $scope.booking_collection.checkItem(res)
            , err => AlertService.danger({msg: 'Something went wrong'}));
    };

    $scope.edit = booking =>
        booking.$getAnswers().then(function (answers) {
            for (let answer of Array.from(answers.answers)) {
                booking[`question${answer.question_id}`] = answer.value;
            }
            return ModalForm.edit({
                model: booking,
                title: 'Booking Details',
                templateUrl: 'edit_booking_modal_form.html',
                success(b) {
                    b = new BBModel.Admin.Booking(b);
                    return $scope.bmap[b.id] = b;
                }
            });
        })
    ;

    // Make sure everytime we enter this view we skip the
    // cache to get the latest state of appointments
    return $scope.getAppointments(null, null, null, null, null, true);
});
