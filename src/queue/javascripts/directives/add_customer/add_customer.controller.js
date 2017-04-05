let AddQueueCustomerController = ($scope, $log, AdminServiceService, AdminQueuerService, ModalForm,
    BBModel, $interval, $sessionStorage, $uibModal, $q, AdminBookingPopup) => {

    let addQueuer = function(form) {
        let defer = $q.defer()
        let service = form.service;
        let person = form.server
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
    }

    $scope.addToQueue = function() {
        let modalInstance = $uibModal.open({
            templateUrl: 'queue/pick_a_service.html',
            scope: $scope,
            controller: ($scope, $uibModalInstance) => {

                $scope.dismiss = () => {
                    console.log('dismiss modal');
                    $uibModalInstance.dismiss('cancel');
                }

                $scope.submit = (form) => $uibModalInstance.close(form)

            }
        });

        modalInstance.result.then(addQueuer).finally(() => $scope.new_queuer = {});
    };

    $scope.serveCustomerNow = function() {
        let modalInstance = $uibModal.open({
            templateUrl: 'queue/serve_now.html',
            resolve: {
                services: () => $scope.services,
                servers: () => {
                    return _.filter($scope.servers, (server) => server.attendance_status == 1);
                }
            },
            controller: ($scope, $uibModalInstance, services, servers) => {

                $scope.form = {};

                $scope.services = services;

                $scope.servers = servers;

                $scope.dismiss = () => $uibModalInstance.dismiss('cancel');

                $scope.submit = (form) => $uibModalInstance.close(form)

            }
        });

        modalInstance.result.then(addQueuer).finally(() => $scope.new_queuer = {});
    };

    $scope.makeAppointment = function(options) {
        let defaultOptions = {
            item_defaults: {
                pick_first_time: true,
                merge_people: true,
                merge_resources: true,
                date: moment().format('YYYY-MM-DD')
            },
            on_conflict: "cancel()",
            company_id: $scope.company.id
        }

        options = _.extend(defaultOptions, options);

        let popup = AdminBookingPopup.open(options);

        popup.result.finally(() => $scope.new_queuer = {});
    };

}

angular.module('BBQueue.controllers').controller('bbQueueAddCustomer', AddQueueCustomerController);
