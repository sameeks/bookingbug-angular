let QueueServerController = ($scope, $log, AdminQueueService, ModalForm, BBModel, CheckSchema,
                             $uibModal, AdminPersonService, $q, AdminQueuerService, AdminQueueLoading, Dialog, $translate) => {

    $scope.AdminQueueLoading = AdminQueueLoading;

    $scope.loadingServer = false;

    let init = function () {
        let bookings = _.filter($scope.bookings.items, booking => {
            return booking.person_id == $scope.person.id;
        });
        if (bookings && bookings.length > 0) {
            $scope.person.next_booking = bookings[0];
        } else {
            $scope.person.next_booking = null;
        }
    };

    $scope.setAttendance = function (person, status, duration) {
        $scope.loadingServer = true;
        person.setAttendance(status, duration).then(function (person) {
            $scope.loadingServer = false;
        }, function (err) {
            $log.error(err.data);
            $scope.loadingServer = false;
        });
    };

    let upcomingBookingCheck = function (person) {
        return person.next_booking && person.next_booking.start.isBefore(moment().add(1, 'hour'));
    };

    $scope.startServingQueuer = function (person, queuer) {
        $scope.loadingServer = true;
        AdminQueueLoading.setLoadingServerInProgress(true);
        if (upcomingBookingCheck(person)) {
            Dialog.confirm({
                title: $translate.instant('ADMIN_DASHBOARD.QUEUE_PAGE.NEXT_BOOKING_DIALOG_HEADING'),
                body: $translate.instant('ADMIN_DASHBOARD.QUEUE_PAGE.NEXT_BOOKING_DIALOG_BODY', {
                    name: person.name, time: person.next_booking.start.format('HH:mm')
                }),
                success: () => {
                    person.startServing(queuer).then(function () {
                        if ($scope.selectQueuer) $scope.selectQueuer(null);
                        $scope.getQueuers();
                        $scope.loadingServer = false;
                        AdminQueueLoading.setLoadingServerInProgress(false);
                    });
                },
                fail: () => {
                    $scope.loadingServer = false;
                    AdminQueueLoading.setLoadingServerInProgress(false);
                }
            });
        } else {
            person.startServing(queuer).then(function () {
                if ($scope.selectQueuer) $scope.selectQueuer(null);
                $scope.getQueuers();
                $scope.loadingServer = false;
                AdminQueueLoading.setLoadingServerInProgress(false);
            });
        }
    };

    $scope.finishServingQueuer = function (options) {
        let {person} = options;
        let {serving} = person;
        $scope.loadingServer = true;
        AdminQueueLoading.setLoadingServerInProgress(true);
        if (options.outcomes) {
            serving.$get('booking').then(function (booking) {
                booking = new BBModel.Admin.Booking(booking);
                booking.current_multi_status = options.status;
                if (booking.$has('edit')) {
                    finishServingOutcome(person, booking);
                } else {
                    $scope.loadingServer = false;
                    AdminQueueLoading.setLoadingServerInProgress(false);
                }
            });
        } else if (options.status) {
            person.finishServing().then(function () {
                serving.$get('booking').then(function (booking) {
                    booking = new BBModel.Admin.Booking(booking);
                    booking.current_multi_status = options.status;
                    booking.$update(booking).then(res => {
                        $scope.loadingServer = false;
                        AdminQueueLoading.setLoadingServerInProgress(false);
                    });
                });
            });
        } else {
            $scope.loadingServer = false;
            AdminQueueLoading.setLoadingServerInProgress(false);
        }
    };

    let finishServingOutcome = function (person, booking) {
        let modalInstance = $uibModal.open({
            templateUrl: 'queue/finish_serving_outcome.html',
            resolve: {
                person: person,
                booking: booking,
                schema: function () {
                    let defer = $q.defer();
                    booking.$get('edit').then(function (schema) {
                        let form = _.reject(schema.form, x => x.type === 'submit');
                        form[0].tabs = [form[0].tabs[form[0].tabs.length - 1]];
                        schema.schem = CheckSchema(schema.schema);
                        defer.resolve(schema);
                    }, function () {
                        defer.reject();
                    });
                    return defer.promise;
                }
            },
            controller: function ($scope, $uibModalInstance, schema, booking, person) {

                $scope.person = person;

                $scope.form_model = booking;

                $scope.form = schema.form;

                $scope.schema = schema.schema;

                $scope.submit = () => $uibModalInstance.close();

                $scope.close = () => $uibModalInstance.dismiss('cancel');

            }
        });

        modalInstance.result.then(function () {
            booking.$update(booking).then(function () {
                person.finishServing().finally(function () {
                    person.attendance_status = 1;
                    $scope.loadingServer = false;
                });
            });
        }, function () {
            $scope.loadingServer = false;
        });
    };

    $scope.updateQueuer = function () {
        $scope.person.$get('queuers').then((collection) => {
            collection.$get('queuers').then((queuers) => {
                queuers = _.map(queuers, (q) => new BBModel.Admin.Queuer(q));
                $scope.person.serving = null;
                let queuer = _.find(queuers, (queuer) => {
                    return queuer.$has('person') && queuer.$href('person') == $scope.person.$href('self');
                });
                $scope.person.serving = queuer;
            });
        });
    };

    $scope.extendAppointment = function (mins) {
        $scope.loadingServer = true;
        $scope.person.serving.extendAppointment(mins).then(function () {
            $scope.loadingServer = false;
        });
    };

    $scope.$on('updateBookings', () => init());

    init();
};

angular.module('BBQueue.controllers').controller('bbQueueServerController', QueueServerController);
