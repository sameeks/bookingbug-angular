angular.module('BBQueue').directive('bbQueueServer', function (BBModel, PusherQueue,
                                                               ModalForm) {

    let pusherListen = function (scope) {
        PusherQueue.subscribe(scope.company);
        return PusherQueue.channel.bind('notification', data => {
                return scope.getQueuers(scope.server);
            }
        );
    };

    let controller = function ($scope) {
        $scope.getQueuers = () => $scope.server.getQueuers();
        $scope.getQueuers = _.throttle($scope.getQueuers, 10000);

        return $scope.newQueuerModal = () =>
            ModalForm.new({
                company: $scope.company,
                title: 'New Queuer',
                new_rel: 'new_queuer',
                post_rel: 'queuers',
                success(queuer) {
                    return $scope.server.queuers.push(queuer);
                }
            })
            ;
    };

    let link = function (scope, element, attrs) {
        if (scope.company) {
            pusherListen(scope);
            return scope.server.getQueuers();
        } else {
            return BBModel.Admin.Company.$query(attrs).then(function (company) {
                scope.company = company;
                if (scope.user.$has('person')) {
                    return scope.user.$get('person').then(function (person) {
                        scope.server = new BBModel.Admin.Person(person);
                        scope.server.getQueuers();
                        return pusherListen(scope);
                    });
                }
            });
        }
    };

    return {
        link,
        controller
    };
});

angular.module('BBQueue').directive('bbQueueServerCustomer', function () {

    let controller = function ($scope) {

        $scope.selected_queuers = [];

        $scope.serveCustomer = function () {
            if ($scope.selected_queuers.length > 0) {
                $scope.loading = true;
                return $scope.server.startServing($scope.selected_queuers).then(function () {
                    $scope.loading = false;
                    return $scope.getQueuers();
                });
            }
        };

        $scope.serveNext = function () {
            $scope.loading = true;
            return $scope.server.startServing().then(function () {
                $scope.loading = false;
                return $scope.getQueuers();
            });
        };

        $scope.extendAppointment = function (mins) {
            $scope.loading = true;
            return $scope.server.serving.extendAppointment(mins).then(function () {
                $scope.loading = false;
                return $scope.getQueuers();
            });
        };

        $scope.finishServing = function () {
            $scope.loading = true;
            return $scope.server.finishServing().then(function () {
                $scope.loading = false;
                return $scope.getQueuers();
            });
        };

        $scope.loading = true;
        if ($scope.server) {
            return $scope.server.setCurrentCustomer().then(() => $scope.loading = false);
        }
    };

    return {
        controller,
        templateUrl: 'queue_server_customer.html'
    };
});

