let QueueDashboardController = ($scope, $log, AdminServiceService, AdminQueuerService, ModalForm,
    BBModel, $interval, $sessionStorage, $uibModal, $q, AdminPersonService) => {

    $scope.loading = true;
    $scope.waiting_for_queuers = false;
    $scope.queuers = [];
    $scope.new_queuer = {};

    // this is used to retrigger a scope check that will update service time
    $interval(function() {
        if ($scope.queuers) {
            return Array.from($scope.queuers).map((queuer) =>
            queuer.remaining());
        }
    }, 5000);

    $scope.getSetup = function() {
        let params =
          {company: $scope.company};
        AdminServiceService.query(params).then(function(services) {
            $scope.services = [];
            for (let service of Array.from(services)) {
                if (!service.queuing_disabled) {
                    $scope.services.push(service);
                }
            }
            return $scope.loading = false;
        }
        , function(err) {
            $log.error(err.data);
            return $scope.loading = false;
        });
    };

    $scope.getQueuers = function() {
        if ($scope.waiting_for_queuers) {
            return;
        }
        $scope.waiting_for_queuers = true;
        let params =
          {company: $scope.company};
        return AdminQueuerService.query(params).then(function(queuers) {
            $scope.queuers = queuers;
            $scope.waiting_queuers = [];
            for (let queuer of Array.from(queuers)) {
                queuer.remaining();
                if (queuer.position > 0) {
                    $scope.waiting_queuers.push(queuer);
                }
            }

            $scope.waiting_queuers = _.sortBy($scope.waiting_queuers, x => x.position);

            $scope.loading = false;
            return $scope.waiting_for_queuers = false;
        }, function(err) {
            $log.error(err.data);
            $scope.loading = false;
            return $scope.waiting_for_queuers = false;
        });
    };

    $scope.dropQueuer = function(event, ui, server, trash) {
        if ($scope.drag_queuer) {
            if (trash) {
                $scope.trash_hover = false;
                $scope.drag_queuer.$del('self').then(function(queuer) {});
            }

            if (server) {
                return $scope.drag_queuer.startServing(server).then(function() {});
            }
        }
    };

    $scope.walkedOut = queuer =>
        queuer.$delete().then(() => $scope.selected_queuer = null);

    $scope.selectQueuer = function(queuer) {
        if ($scope.selected_queuer && ($scope.selected_queuer === queuer)) {
            return $scope.selected_queuer = null;
        } else {
            return $scope.selected_queuer = queuer;
        }
    };

    $scope.selectDragQueuer = queuer => $scope.drag_queuer = queuer;

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

angular.module('BBQueue.controllers').controller('bbQueueDashboard', QueueDashboardController);
