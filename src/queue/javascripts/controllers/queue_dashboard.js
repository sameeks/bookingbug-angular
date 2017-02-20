angular.module('BBQueue').controller('bbQueueDashboardController', function ($scope,
                                                                             $log, $interval, $sessionStorage, ModalForm, BBModel) {

    $scope.loading = true;
    $scope.waiting_for_queuers = false;
    $scope.queuers = [];
    $scope.new_queuer = {};

    $scope.getSetup = function () {
        let params =
            {company: $scope.company};
        BBModel.Admin.Service.$query(params).then(function (services) {
                $scope.services = [];
                for (let service of Array.from(services)) {
                    if (!service.queuing_disabled) {
                        $scope.services.push(service);
                    }
                }
                return $scope.loading = false;
            }
            , function (err) {
                $log.error(err.data);
                return $scope.loading = false;
            });
        $scope.pusherSubscribe();
        return $scope.getQueuers();
    };

    $scope.getQueuers = function () {
        if ($scope.waiting_for_queuers) {
            return;
        }
        $scope.waiting_for_queuers = true;
        let params =
            {company: $scope.company};
        return BBModel.Admin.Queuer.$query(params).then(function (queuers) {
                $scope.queuers = queuers;
                $scope.waiting_queuers = [];
                for (let queuer of Array.from(queuers)) {
                    queuer.remaining();
                    if (queuer.position > 0) {
                        $scope.waiting_queuers.push(queuer);
                    }
                }

                $scope.loading = false;
                return $scope.waiting_for_queuers = false;
            }
            , function (err) {
                $log.error(err.data);
                $scope.loading = false;
                return $scope.waiting_for_queuers = false;
            });
    };

    $scope.overTrash = (event, ui, set) =>
        $scope.$apply(() => $scope.trash_hover = set)
    ;

    $scope.hoverOver = (event, ui, obj, set) =>
        $scope.$apply(() => obj.hover = set)
    ;

    $scope.dropQueuer = function (event, ui, server, trash) {
        if ($scope.drag_queuer) {
            if (trash) {
                $scope.trash_hover = false;
                $scope.drag_queuer.$del('self').then(function (queuer) {
                });
            }

            if (server) {
                return $scope.drag_queuer.startServing(server).then(function () {
                });
            }
        }
    };

    $scope.selectQueuer = function (queuer) {
        if ($scope.selected_queuer && ($scope.selected_queuer === queuer)) {
            return $scope.selected_queuer = null;
        } else {
            return $scope.selected_queuer = queuer;
        }
    };

    $scope.selectDragQueuer = queuer => $scope.drag_queuer = queuer;

    $scope.addQueuer = function (service) {
        $scope.new_queuer.service_id = service.id;
        return service.$post('queuers', {}, $scope.new_queuer).then(function (queuer) {
        });
    };

    $scope.pusherSubscribe = () => {
        if (($scope.company != null) && (typeof Pusher !== 'undefined' && Pusher !== null)) {
            if ($scope.pusher == null) {
                $scope.pusher = new Pusher('c8d8cea659cc46060608', {
                        authEndpoint: `/api/v1/push/${$scope.company.id}/pusher.json`,
                        auth: {
                            headers: {
                                // These should be put somewhere better - any suggestions?
                                'App-Id': 'f6b16c23',
                                'App-Key': 'f0bc4f65f4fbfe7b4b3b7264b655f5eb',
                                'Auth-Token': $sessionStorage.getItem('auth_token')
                            }
                        }
                    }
                );
            }

            let channelName = `mobile-queue-${$scope.company.id}`;

            if ($scope.pusher.channel(channelName) == null) {
                $scope.pusher_channel = $scope.pusher.subscribe(channelName);

                let pusherEvent = res => {
                    return $scope.getQueuers();
                };

                return $scope.pusher_channel.bind('notification', pusherEvent);
            }
        }
    };

    // this is used to retrigger a scope check that will update service time
    return $interval(function () {
            if ($scope.queuers) {
                return Array.from($scope.queuers).map((queuer) =>
                    queuer.remaining());
            }
        }
        , 5000);
});

