let QueueDashboardController = ($scope, $log, AdminServiceService, AdminQueuerService, ModalForm,
    BBModel, $interval, $sessionStorage, $uibModal, $q) => {

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

}

angular.module('BBQueue.controllers').controller('bbQueueDashboard', QueueDashboardController);
