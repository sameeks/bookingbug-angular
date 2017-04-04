angular.module('BBQueue.directives').directive('bbServerListItem', () => {
    return {
        controller: ($scope, $log, AdminQueueService, ModalForm, BBModel, CheckSchema, $uibModal,
            AdminPersonService) => {

            $scope.setAttendance = function(person, status, duration) {
                $scope.loading = true;
                return person.setAttendance(status, duration).then(function(person) {
                    $scope.loading = false;
                }, function(err) {
                    $log.error(err.data);
                    return $scope.loading = false;
                });
            };

            $scope.finishServingQueuer = function(options) {
                let { person } = options;
                let { serving } = person;
                $scope.loadingServer += 1;
                if (options.status) {
                    person.finishServing().then(function(res) {
                        $scope.loadingServer -= 1;
                        serving.$get('booking').then(function(booking) {
                            booking = new BBModel.Admin.Booking(booking);
                            booking.current_multi_status = options.status;
                            booking.$update(booking).then(res => {
                                // $scope.getQueuers()
                            });
                        });
                    });
                }

                if (options.outcomes) {
                    $scope.person = person;
                    $scope.loadingServer += 1;
                    serving.$get('booking').then(function(booking) {
                        $scope.booking = new BBModel.Admin.Booking(booking);
                        if ($scope.booking.$has('edit')) {
                            return $scope.booking.$get('edit').then(function(schema) {
                                $scope.form = _.reject(schema.form, x => x.type === 'submit');
                                $scope.form[0].tabs = [$scope.form[0].tabs[$scope.form[0].tabs.length-1]];
                                $scope.schema = CheckSchema(schema.schema);
                                $scope.form_model = $scope.booking;
                                $scope.loading = false;
                                return $scope.finishServingOutcome($scope.person, $scope.booking);
                            });
                        }
                    });
                }
                // return $scope.getQueuers();
            };

            $scope.finishServingOutcome = function(person, booking) {
                let modalInstance = $uibModal.open({
                    templateUrl: 'queue/finish_serving_outcome.html',
                    scope: $scope,
                    controller: ($scope, $uibModalInstance) => {
                        $scope.submit = () => {
                            $uibModalInstance.close();
                        },
                        $scope.close = () => {
                            $uibModalInstance.dismiss('cancel');
                        }
                    }
                });

                modalInstance.result.then(() => {
                    $scope.loadingServer -= 1;
                    booking.$put('self', {}, booking).then(() => person.finishServing());
                }, () => {
                    $scope.loadingServer -= 1;
                });
            }

            $scope.serveNow = function() {
                $scope.loadingServer += 1;
                let modalInstance = $uibModal.open({
                    templateUrl: 'queue/pick_a_service_now.html',
                    scope: $scope,
                    controller: ($scope, $uibModalInstance) => {
                        $scope.close = () => {
                            $uibModalInstance.close();
                        }
                    }
                });

                modalInstance.result.finally(() => $scope.loadingServer -= 1);
            };

            $scope.loadingServer = 0;

        },
        link: (scope, element, attrs) => {
            console.log('server list item link');
        }
    }
});
