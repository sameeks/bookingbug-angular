angular.module('BBAdminBooking').factory 'AdminMoveBookingPopup', ($uibModal, $timeout, $document) ->

  open: (config) ->
    modal = $uibModal.open
      appendTo: angular.element($document[0].getElementById('bb'))
      size: 'lg'
      controller: ($scope, $uibModalInstance, config, $window, AdminBookingOptions) ->
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
          $uibModalInstance.dismiss('cancel')
      templateUrl: 'admin_move_booking_popup.html'
      resolve:
        config: () -> config
    modal.result.then (result) ->
      # success
      if config.success
        config.success()
      return result;
    , (err) ->
      if config.fail
        config.fail()
      return err
