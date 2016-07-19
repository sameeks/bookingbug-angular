angular.module('BBAdminBooking').factory 'AdminMoveBookingPopup', ($modal, $timeout) ->

  open: (config) ->
    $modal.open
      size: 'lg'
      controller: ($scope, $modalInstance, config, $window, AdminBookingOptions) ->
        $scope.Math = $window.Math
        if $scope.bb && $scope.bb.current_item
          delete $scope.bb.current_item
        $scope.config = angular.extend
          clear_member: true
          template: 'main'
        , config
        $scope.config.company_id ||= $scope.company.id if $scope.company
        $scope.config.item_defaults = angular.extend
          merge_resources: AdminBookingOptions.merge_resources
          merge_people: AdminBookingOptions.merge_people
        , config.item_defaults
        $scope.cancel = () ->
          $modalInstance.dismiss('cancel')
      templateUrl: 'admin_move_booking_popup.html'
      resolve:
        config: () -> config
