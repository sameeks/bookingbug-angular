angular.module('BBAdmin.Controllers').controller('DashboardContainer', function ($scope, $rootScope, $location, $uibModal, $document) {

    $scope.selectedBooking = null;
    $scope.poppedBooking = null;

    $scope.selectBooking = booking => $scope.selectedBooking = booking;

    $scope.popupBooking = function (booking) {
        $scope.poppedBooking = booking;

        let modalInstance = $uibModal.open({
            templateUrl: 'full_booking_details',
            controller: ModalInstanceCtrl,
            scope: $scope,
            backdrop: true,
            resolve: {
                items: () => {
                    return {booking};
                }
            }
        });

        return modalInstance.result.then(selectedItem => {
                return $scope.selected = selectedItem;
            }
            , () => {
                return console.log(`Modal dismissed at: ${new Date()}`);
            }
        );
    };

    var ModalInstanceCtrl = function ($scope, $uibModalInstance, items) {
        angular.extend($scope, items);
        $scope.ok = function () {
            if (items.booking && items.booking.self) {
                items.booking.$update();
            }
            return $uibModalInstance.close();
        };
        return $scope.cancel = () => $uibModalInstance.dismiss('cancel');
    };

    // a popup performing an action on a time, possible blocking, or mkaing a new booking
    return $scope.popupTimeAction = function (prms) {

        let modalInstance;
        return modalInstance = $uibModal.open({
            templateUrl: $scope.partial_url + 'time_popup',
            controller: ModalInstanceCtrl,
            scope: $scope,
            backdrop: false,
            resolve: {
                items: () => prms
            }
        });
    };
});
