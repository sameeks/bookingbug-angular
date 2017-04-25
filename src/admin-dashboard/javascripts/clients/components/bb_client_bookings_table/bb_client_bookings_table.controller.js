(function () {

    angular
        .module('BBAdminDashboard.clients.controllers')
        .controller('bbClientBookingsTableCtrl', bbClientBookingsTableCtrl);

    function bbClientBookingsTableCtrl($rootScope, $scope, $log, $uibModal, BBModel, ModalForm, AdminMoveBookingPopup) {

        $scope.$watch('member', (member) => {
            return getBookings($scope, member);
        });


        /***
         * @ngdoc method
         * @name edit
         * @methodOf BBAdminDashboard.clients.directives:bbClientBookingsTable
         * @description
         * Opens modal to edit client's booking details
         *
         * @param {integer} id The id of the booking to be edited
        */
        $scope.edit = (id) => {
            let booking = _.find($scope.booking_models, b => b.id === id);
            booking.$getAnswers().then((answers) => {
                for (let answer of Array.from(answers.answers)) {
                    booking[`question${answer.question_id}`] = answer.value;
                }
                ModalForm.edit({
                    model: booking,
                    title: 'Booking Details',
                    templateUrl: 'edit_booking_modal_form.html',
                        success(response) {
                            handleModal(response, booking);
                        }
                    }
                );
            });
        };


        /***
         * @ngdoc method
         * @name edit
         * @methodOf BBAdminDashboard.clients.directives:bbClientBookingsTable
         * @description
         * Opens modal to cancel client's booking
         *
         * @param {integer} id The id of the booking to be cancelled
         */
        $scope.cancel = (id) => {
            const booking = _.find($scope.booking_models, b => b.id === id);

            const modalInstance = $uibModal.open({
                templateUrl: 'member_bookings_table_cancel_booking.html',
                controller($scope, $uibModalInstance, booking) {
                    $scope.booking = booking;
                    $scope.booking.notify = true;
                    $scope.ok = () => $uibModalInstance.close($scope.booking);
                    return $scope.close = () => $uibModalInstance.dismiss();
                },
                scope: $scope,
                resolve: {
                    booking() {
                        return booking;
                    }
                }
            });

            modalInstance.result.then((booking) => {
                cancelBooking(booking);
            });
        };


        const init = () => {
            if (!$scope.startDate) {
                $scope.startDate = moment();
            }

            if ($scope.member) {
                return getBookings($scope, $scope.member);
            }
        };


        const handleModal = (response, booking) => {
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
        };


        const updateBooking = b => {
            b.$refetch().then((b) => {
                b = new BBModel.Admin.Booking(b);
                let i = _.indexOf($scope.booking_models, b => b.id === id);
                $scope.booking_models[i] = b;
                setRows();
            });
        };

        const cancelBooking = (booking) => {
            const params = {notify: booking.notify};
            return booking.$post('cancel', params).then(() => {
                const bookingIndex = _.findIndex($scope.booking_models, (b) => {
                    return b.id === booking.id;
                });
                $scope.booking_models.splice(bookingIndex, 1);
                setRows();
            });
        };


        const getBookings = ($scope, member) => {
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
        };


        const handleCustomerBookings = (bookings) => {
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
        };


        const setRows = () =>
            $scope.bookings = _.map($scope.booking_models, booking => {
                return {
                    id: booking.id,
                    date: moment(booking.datetime).format('YYYY-MM-DD'),
                    date_order: moment(booking.datetime).format('x'),
                    datetime: moment(booking.datetime),
                    details: booking.full_describe
                };
            }
        );


        init();
    }

})();

