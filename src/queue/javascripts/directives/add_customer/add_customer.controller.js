let AddQueueCustomerController = ($scope, $log, AdminServiceService, AdminQueuerService, ModalForm,
                                  BBModel, $interval, $sessionStorage, $uibModal, $q, AdminBookingPopup) => {

    let addQueuer = function (form) {
        let defer = $q.defer();
        let service = form.service;
        let person = form.server;
        $scope.new_queuer.service_id = service.id;
        service.$post('queuers', {}, $scope.new_queuer).then((response) => {
            let queuer = new BBModel.Admin.Queuer(response);
            if (person) {
                queuer.startServing(person).then(() => {
                    defer.resolve();
                }, () => {
                    defer.reject();
                });
            } else {
                defer.resolve();
            }
        });
        return defer.promise;
    };

    let resetQueuer = function () {
        $scope.new_queuer = {};
        $scope.loading = false;
    };

    $scope.addToQueue = function () {
        $scope.loading = true;
        let modalInstance = $uibModal.open({
            templateUrl: 'queue/pick_a_service.html',
            scope: $scope,
            controller: ($scope, $uibModalInstance) => {

                $scope.dismiss = () => $uibModalInstance.dismiss('cancel');

                $scope.submit = (form) => $uibModalInstance.close(form);

            }
        });

        modalInstance.result.then(addQueuer).then(resetQueuer).finally(() => $scope.loading = false);
    };

    $scope.availableServers = function () {
        return _.filter($scope.servers, (server) => server.attendance_status == 1);
    };

    $scope.serveCustomerNow = function () {
        $scope.loading = true;
        let modalInstance = $uibModal.open({
            templateUrl: 'queue/serve_now.html',
            resolve: {
                services: () => $scope.services,
                servers: () => {
                    return $scope.availableServers();
                }
            },
            controller: ($scope, $uibModalInstance, services, servers) => {

                $scope.form = {};

                $scope.services = services;

                $scope.servers = servers;

                $scope.dismiss = () => $uibModalInstance.dismiss('cancel');

                $scope.submit = (form) => $uibModalInstance.close(form);

            }
        });

        modalInstance.result.then(addQueuer).then(resetQueuer).finally(() => $scope.loading = false);
    };

    $scope.makeAppointment = function (options) {
        let defaultOptions = {
            item_defaults: {
                pick_first_time: true,
                merge_people: true,
                merge_resources: true,
                date: moment().format('YYYY-MM-DD')
            },
            on_conflict: "cancel()",
            company_id: $scope.company.id
        };

        options = _.extend(defaultOptions, options);

        let popup = AdminBookingPopup.open(options);

        popup.result.finally(resetQueuer);
    };

};

angular.module('BBQueue.controllers').controller('bbQueueAddCustomer', AddQueueCustomerController);
