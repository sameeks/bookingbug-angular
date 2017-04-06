let QueueServerController =  ($scope, $log, AdminQueueService, ModalForm, BBModel, CheckSchema,
    $uibModal, AdminPersonService, $q) => {

    $scope.setAttendance = function(person, status, duration) {
        $scope.loadingServer = true;
        person.setAttendance(status, duration).then(function(person) {
            $scope.loadingServer = false;
        }, function(err) {
            $log.error(err.data);
            $scope.loadingServer = false;
        });
    };

    $scope.startServingQueuer = function(person, queuer) {
        $scope.loadingServer = true;
        person.startServing(queuer).then(function() {
            $scope.selectQueuer(null);
            $scope.getQueuers();
            $scope.loadingServer = false;
        });
    };

    $scope.finishServingQueuer = function(options) {
        let { person } = options;
        let { serving } = person;
        $scope.loadingServer = true;
        if (options.outcomes) {
            serving.$get('booking').then(function(booking) {
                booking = new BBModel.Admin.Booking(booking);
                booking.current_multi_status = options.status;
                if (booking.$has('edit')) {
                    finishServingOutcome(person, booking);
                } else {
                    $scope.loadingServer = false;
                }
            });
        } else if (options.status) {
            person.finishServing().then(function() {
                serving.$get('booking').then(function(booking) {
                    booking = new BBModel.Admin.Booking(booking);
                    booking.current_multi_status = options.status;
                    booking.$update(booking).then(res => {
                        $scope.loadingServer = false;
                    });
                });
            });
        } else {
            $scope.loadingServer = false;
        }
    };

    let finishServingOutcome = function(person, booking) {
        let modalInstance = $uibModal.open({
            templateUrl: 'queue/finish_serving_outcome.html',
            resolve: {
                person: person,
                booking: booking,
                schema: function() {
                    let defer = $q.defer();
                    booking.$get('edit').then(function(schema) {
                        let form = _.reject(schema.form, x => x.type === 'submit');
                        form[0].tabs = [form[0].tabs[form[0].tabs.length-1]];
                        schema.schem = CheckSchema(schema.schema);
                        defer.resolve(schema);
                    }, function() {
                        defer.reject();
                    });
                    return defer.promise;
                }
            },
            controller: function($scope, $uibModalInstance, schema, booking, person) {

                $scope.person = person;

                $scope.form_model = booking;

                $scope.form = schema.form;

                $scope.schema = schema.schema;

                $scope.submit = () => $uibModalInstance.close();

                $scope.close = () => $uibModalInstance.dismiss('cancel');

            }
        });

        modalInstance.result.then(function() {
            booking.$update(booking).then(function() {
                person.finishServing().finally(function() {
                    person.attendance_status = 1;
                    $scope.loadingServer = false;
                });
            });
        }, function() {
            $scope.loadingServer = false;
        });
    }

    $scope.loadingServer = false;
};

angular.module('BBQueue.controllers').controller('bbQueueServerController', QueueServerController);
