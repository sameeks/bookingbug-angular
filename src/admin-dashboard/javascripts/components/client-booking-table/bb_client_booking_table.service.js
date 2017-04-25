(function () {

    /**
     * @ngdoc service
     * @name BBAdminDashboard.ClientBookingTableService
     *
     * @description
     * Responsible for getting  customer booking data
     *
    */

    angular
        .module('BBAdminDashboard')
        .factory('ClientBookingTableService', ClientBookingTableService);

    function ClientBookingTableService($q, BBModel, $rootScope) {
        return {
            handleModal(response, booking) {
                // if we are moving the booking
                if (typeof response === 'string' && response === "move") {
                    let item_defaults = {person: booking.person_id, resource: booking.resource_id};
                    return AdminMoveBookingPopup.open({
                        item_defaults,
                        company_id: booking.company_id,
                        booking_id: booking.id,
                        success: model => {
                            return updateBooking(booking);
                        },
                        fail: model => {
                            return updateBooking(booking);
                        }
                    });

                } else {
                    return updateBooking(booking);
                }
            },


            updateBooking(b) {
                b.$refetch().then((b) => {
                    b = new BBModel.Admin.Booking(b);
                    let i = _.indexOf($scope.booking_models, b => b.id === id);
                    $scope.booking_models[i] = b;
                    setRows();
                });
            },

            cancelBooking(booking) {
                const params = {notify: booking.notify};
                return booking.$post('cancel', params).then(() => {
                    const bookingIndex = _.findIndex($scope.booking_models, (b) => {
                        return b.id === booking.id;
                    });
                    $scope.booking_models.splice(bookingIndex, 1);
                    setRows();
                });
            },


            getBookings($scope, member) {
                const params = {
                    start_date: $scope.startDate.format('YYYY-MM-DD'),
                    start_time: $scope.startTime ? $scope.startTime.format('HH:mm') : undefined,
                    end_date: $scope.endDate ? $scope.endDate.format('YYYY-MM-DD') : undefined,
                    end_time: $scope.endTime ? $scope.endTime.format('HH:mm') : undefined,
                    company: $rootScope.bb.company,
                    url: $rootScope.bb.api_url,
                    client_id: member.id,
                    skip_cache: true
                };


                BBModel.Admin.Booking.$query(params).then((bookings) => {
                    handleCustomerBookings(bookings);
                }
                , (err) => {
                    $log.error(err.data);
                });
            },


            handleCustomerBookings(bookings) {
                const timeNow = moment().unix();
                if ($scope.period && ($scope.period === "past")) {
                    $scope.booking_models = _.filter(bookings.items, x => x.datetime.unix() < timeNow);
                } else if ($scope.period && ($scope.period === "future")) {
                    $scope.booking_models = _.filter(bookings.items, x => x.datetime.unix() > timeNow);
                } else {
                    $scope.booking_models = bookings.items;
                }
                setRows();

                if($scope.bookings.length > 0) {
                   $rootScope.$broadcast('bookings:loaded', $scope.bookings);
                }
            },


            setRows() {
                $scope.bookings = _.map($scope.booking_models, booking => {
                    return {
                        id: booking.id,
                        date: moment(booking.datetime).format('YYYY-MM-DD'),
                        date_order: moment(booking.datetime).format('x'),
                        datetime: moment(booking.datetime),
                        details: booking.full_describe
                    };
                });
            }
        };
    }
})();



