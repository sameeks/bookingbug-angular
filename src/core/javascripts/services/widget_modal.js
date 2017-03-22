(() => {

    angular
        .module('BB')
        .factory('WidgetModalService', WidgetModal);

    function WidgetModal($uibModal, $timeout, $document, $uibModalStack, AlertService) {
        let service = {
            open: open,
            close: close
        }

        return service;

        function open(config) {
            let modal = $uibModal.open({
                size: 'lg',
                templateUrl: 'widget_modal.html',
                controller($scope, WidgetModalService, config) {
                    $scope.config = config;
                    if ($scope.bb && $scope.bb.current_item) {
                        delete $scope.bb.current_item;
                    }
                    WidgetModalService.config = config;
                    if ($scope.company) {
                        if (!$scope.config.company_id) {
                            $scope.config.company_id = $scope.company.id;
                        }
                    }
                    $scope.cancel = () =>
                        WidgetModalService.close()
                },
                resolve: {
                    config: function() {
                        return config;
                    }
                }
            });

            return modal;
        }

        function close() {
            let openModal = $uibModalStack.getTop();

            AlertService.clear();
            $uibModalStack.close(openModal.key);

            if(this.bookings) {
                if(this.bookings[0].moved) {
                    AlertService.showMoveMessage(this.bookings[0].datetime);
                }
            }
        }
    }
})();

