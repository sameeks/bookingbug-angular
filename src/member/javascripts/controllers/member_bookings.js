// TODO: This file was created by bulk-decaffeinate.
// Sanity-check the conversion and remove this comment.
angular.module('BBMember').controller('MemberBookings', function ($scope, $uibModal,
                                                                  $document, $log, $q, ModalForm, $rootScope, AlertService, PurchaseService,
                                                                  LoadingService, BBModel) {

    let loader = LoadingService.$loader($scope);

    $scope.getUpcomingBookings = function () {
        let defer = $q.defer();
        let now = moment();
        let params =
            {start_date: now.toISODate()};
        getBookings(params).then(function (results) {
                $scope.upcoming_bookings = _.filter(results, result => result.datetime.isAfter(now));
                return defer.resolve($scope.upcoming_bookings);
            }
            , err => defer.reject([]));
        return defer.promise;
    };


    $scope.getPastBookings = function (num, type) {
        let date;
        let defer = $q.defer();
        // default to year in the past if no amount is specified
        if (num && type) {
            date = moment().subtract(num, type);
        } else {
            date = moment().subtract(1, 'year');
        }
        let params = {
            start_date: date.format('YYYY-MM-DD'),
            end_date: moment().add(1, 'day').format('YYYY-MM-DD')
        };
        getBookings(params).then(function (past_bookings) {
                $scope.past_bookings = _.chain(past_bookings)
                    .filter(b => b.datetime.isBefore(moment()))
                    .sortBy(b => -b.datetime.unix())
                    .value();
                return defer.resolve(past_bookings);
            }
            , err => defer.reject([]));
        return defer.promise;
    };


    $scope.flushBookings = function () {
        let params =
            {start_date: moment().format('YYYY-MM-DD')};
        return $scope.member.$flush('bookings', params);
    };


    let updateBookings = () => $scope.getUpcomingBookings();


    var getBookings = function (params) {
        loader.notLoaded();
        let defer = $q.defer();
        $scope.member.getBookings(params).then(function (bookings) {
                loader.setLoaded();
                return defer.resolve(bookings);
            }
            , function (err) {
                $log.error(err.data);
                return loader.setLoaded();
            });
        return defer.promise;
    };


    $scope.cancelBooking = function (booking) {
        let index = _.indexOf($scope.upcoming_bookings, booking);
        _.without($scope.upcoming_bookings, booking);
        return BBModel.Member.Booking.$cancel($scope.member, booking).then(function () {
                AlertService.raise('BOOKING_CANCELLED');
                $rootScope.$broadcast("booking:cancelled");
                // does a removeBooking method exist in the scope chain?
                if ($scope.removeBooking) {
                    return $scope.removeBooking(booking);
                }
            }
            , function (err) {
                AlertService.raise('GENERIC');
                return $scope.upcoming_bookings.splice(index, 0, booking);
            });
    };


    $scope.getPrePaidBookings = function (params) {
        let defer = $q.defer();
        $scope.member.$getPrePaidBookings(params).then(function (bookings) {
                $scope.pre_paid_bookings = bookings;
                return defer.resolve(bookings);
            }
            , function (err) {
                defer.reject([]);
                return $log.error(err.data);
            });
        return defer.promise;
    };


    let bookWaitlistSucces = function () {
        AlertService.raise('WAITLIST_ACCEPTED');
        return updateBookings();
    };


    let openPaymentModal = function (booking, total) {
        let modalInstance = $uibModal.open({
            templateUrl: "booking_payment_modal.html",
            windowClass: "bbug",
            size: "lg",
            controller($scope, $uibModalInstance, booking, total) {

                $scope.booking = booking;
                $scope.total = total;

                $scope.handlePaymentSuccess = () => $uibModalInstance.close(booking);

                return $scope.cancel = () => $uibModalInstance.dismiss("cancel");
            },

            resolve: {
                booking() {
                    return booking;
                },
                total() {
                    return total;
                }
            }
        });

        return modalInstance.result.then(booking => bookWaitlistSucces());
    };


    return {
        edit(booking) {
            return booking.$getAnswers().then(function (answers) {
                for (let answer of Array.from(answers.answers)) {
                    booking[`question${answer.question_id}`] = answer.value;
                }
                return ModalForm.edit({
                    model: booking,
                    title: 'Booking Details',
                    templateUrl: 'edit_booking_modal_form.html',
                    windowClass: 'member_edit_booking_form',
                    success: updateBookings
                });
            });
        },


        cancel(booking) {
            let modalInstance = $uibModal.open({
                templateUrl: "member_booking_delete_modal.html",
                windowClass: "bbug",
                controller($scope, $rootScope, $uibModalInstance, booking) {
                    $scope.booking = booking;

                    $scope.confirm_delete = () => $uibModalInstance.close(booking);

                    return $scope.cancel = () => $uibModalInstance.dismiss("cancel");
                },
                resolve: {
                    booking() {
                        return booking;
                    }
                }
            });
            return modalInstance.result.then(booking => $scope.cancelBooking(booking));
        },


        book(booking) {
            loader.notLoaded();
            let params = {
                purchase_id: booking.purchase_ref,
                url_root: $rootScope.bb.api_url,
                booking
            };
            PurchaseService.bookWaitlistItem(params).then(function (purchase_total) {
                    if (purchase_total.due_now > 0) {
                        if (purchase_total.$has('new_payment')) {
                            return openPaymentModal(booking, purchase_total);
                        } else {
                            return $log.error(`total is missing new_payment link, this is usually caused \
by online payment not being configured correctly`
                            );
                        }
                    } else {
                        return bookWaitlistSucces();
                    }
                }
                , err => AlertService.raise('NO_WAITLIST_SPACES_LEFT'));
            return loader.setLoaded();
        },


        pay(booking) {
            let params = {
                url_root: $scope.$root.bb.api_url,
                purchase_id: booking.purchase_ref
            };
            return PurchaseService.query(params).then(total => openPaymentModal(booking, total));
        }
    };
});
