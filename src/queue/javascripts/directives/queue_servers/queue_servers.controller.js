let QueueServersController = ($scope, $log, AdminQueueService, ModalForm, AdminPersonService,
    BBModel, $uibModal, CheckSchema) => {

    $scope.loading = true;

    $scope.getServers = function() {
        if ($scope.getting_people) {
            return;
        }
        $scope.company.$flush('people');
        $scope.getting_people = true;
        return AdminPersonService.query({company: $scope.company}).then(function(people) {
            $scope.getting_people = false;
            $scope.all_people = people;
            $scope.servers = [];
            for (let person of Array.from($scope.all_people)) {
                if (!person.queuing_disabled) {
                    $scope.servers.push(person);
                }
            }

            $scope.servers = _.sortBy($scope.servers, function(server) {
                if (server.attendance_status === 1) { // available
                    return 0;
                }
                if (server.attendance_status === 4) { // serving/busy
                    return 1;
                }
                if (server.attendance_status === 2) { // on a break
                    return 2;
                }
                if (server.attendance_status === 3) { // other
                    return 3;
                }
                if (server.attendance_status === 3) { // off shift
                    return 4;
                }
            });

            $scope.loading = false;
            return $scope.updateQueuers();
        }, function(err) {
            $scope.getting_people = false;
            $log.error(err.data);
            return $scope.loading = false;
        });
    };

    $scope.setAttendance = function(person, status, duration) {
        $scope.loading = true;
        return person.setAttendance(status, duration).then(function(person) {
            $scope.loading = false;
        }, function(err) {
            $log.error(err.data);
            return $scope.loading = false;
        });
    };

    $scope.$watch('queuers', (newValue, oldValue) => {
        return $scope.getServers();
    });

    $scope.updateQueuers = function() {
        if ($scope.queuers && $scope.servers) {
            let shash = {};
            for (let server of Array.from($scope.servers)) {
                server.serving = null;
                shash[server.self] = server;
            }
            return (() => {
                let result = [];
                for (let queuer of Array.from($scope.queuers)) {
                    let item;
                    if (queuer.$href('person') && shash[queuer.$href('person')] && (queuer.position === 0)) {
                        item = shash[queuer.$href('person')].serving = queuer;
                    }
                    result.push(item);
                }
                return result;
            })();
        }
    };

    $scope.startServingQueuer = (person, queuer) => {
        person.startServing(queuer).then(function() {
            $scope.selectQueuer(null);
            return $scope.getQueuers();
        });
    }

    $scope.finishServingQueuer = function(options) {
        let { person } = options;
        let { serving } = person;
        if (options.status) {
            person.finishServing().then(function(res) {
                return serving.$get('booking').then(function(booking) {
                    booking = new BBModel.Admin.Booking(booking);
                    booking.current_multi_status = options.status;
                    return booking.$update(booking).then(res => $scope.getQueuers());
                });
            });
        }

        if (options.outcomes) {
            $scope.person = person;
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
        return $scope.getQueuers();
    };

    $scope.finishServingOutcome = function(person, booking) {
        let modalInstance = $uibModal.open({
            templateUrl: 'queue/finish_serving_outcome.html',
            scope: $scope,
            controller: ($scope, $uibModalInstance) => {
                $scope.submit = () => $uibModalInstance.close();
                $scope.close = () => $uibModalInstance.dismiss('cancel');
            }
        });

        modalInstance.result.then(() => {
            booking.$put('self', {}, booking).then(() => person.finishServing());
        });
    }

    $scope.dropCallback = function(event, ui, queuer, $index) {
        $scope.$apply(() => $scope.selectQueuer(null));
        return false;
    };

    $scope.dragStart = function(event, ui, queuer) {
        $scope.$apply(function() {
            $scope.selectDragQueuer(queuer);
            return $scope.selectQueuer(queuer);
        });
        return false;
    };

    return $scope.dragStop = function(event, ui) {
        $scope.$apply(() => $scope.selectQueuer(null));
        return false;
    };
}

angular.module('BBQueue.controllers').controller('bbQueueServers', QueueServersController);
