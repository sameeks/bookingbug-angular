angular
    .module('BBAdminDashboard.check-in.directives')
    .controller('bbCheckInController', bbCheckInController);

function bbCheckInController($scope, $q, ModalForm, AlertService, BBModel) {

    $scope.getAppointments = (currentPage, filterBy, filterByFields, orderBy, orderByReverse, skipCache) => {
        buildParams(currentPage, filterBy, filterByFields, orderBy, orderByReverse, skipCache);
    };


    let buildParams = (current_page, filter_by, filter_by_fields, order_by, order_by_reverse, skip_cache) => {
        let date = moment().format('YYYY-MM-DD');
        let company = $scope.bb.company;
        let url = $scope.bb.api_url;

        let params = {
            company,
            date,
            url,
            current_page,
            filter_by,
            filter_by_fields,
            order_by,
            order_by_reverse,
            skip_cache
        };

        queryAdminBookings(params);
    }

    let queryAdminBookings = (params) => {
        let defer = $q.defer()
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
            setCheckInGridData(Array.from(res.items));

            // update the items if they've changed
            $scope.booking_collection.addCallback($scope, (booking, status) => {
                handleBookingChanges(booking, status);
            });

            return defer.resolve($scope.bookings);
        }
        , err => defer.reject(err));
        return defer.promise;
    }

    let setCheckInGridData = (bookings) => {
        $scope.gridOptions.data = bookings;
    }


    let handleBookingChanges = (booking, status) => {
        $scope.bookings = [];
        $scope.bmap = {};
        return (() => {
            let result = [];
            for (let item of Array.from($scope.booking_collection.items)) {
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

    $scope.setStatus = (booking, status) => {
        let clone = _.clone(booking);
        clone.current_multi_status = status;
        return booking.$update(clone).then(res => $scope.booking_collection.checkItem(res)
            , err => AlertService.danger({msg: 'Something went wrong'}));
    };

    $scope.edit = booking => {
        booking.$getAnswers().then((answers) => {
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
        });
    }
};


