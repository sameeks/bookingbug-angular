// TODO: This file was created by bulk-decaffeinate.
// Sanity-check the conversion and remove this comment.
angular.module('BBAdminBooking').factory('AdminMoveBookingPopup', ($uibModal, $timeout, $document) =>

  ({
    open(config) {
      let modal = $uibModal.open({
        size: 'lg',
        controller($scope, $uibModalInstance, config, $window, AdminBookingOptions) {
          $scope.Math = $window.Math;
          if ($scope.bb && $scope.bb.current_item) {
            delete $scope.bb.current_item;
          }
          $scope.config = angular.extend({
            clear_member: true,
            template: 'main'
          }
          , config);
          if ($scope.company) { if (!$scope.config.company_id) { $scope.config.company_id = $scope.company.id; } }
          $scope.config.item_defaults = angular.extend({
            merge_resources: AdminBookingOptions.merge_resources,
            merge_people: AdminBookingOptions.merge_people
          }
          , config.item_defaults);
          return $scope.cancel = () => $uibModalInstance.dismiss('cancel');
        },
        templateUrl: 'admin_move_booking_popup.html',
        resolve: {
          config() { return config; }
        }
      });
      return modal.result.then(function(result) {
        // success
        if (config.success) {
          config.success();
        }
        return result;
      }
      , function(err) {
        if (config.fail) {
          config.fail();
        }
        return err;
      });
    }
  })
);
