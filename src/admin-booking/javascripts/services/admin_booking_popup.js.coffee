'use strict'

angular.module('BBAdminBooking').factory 'AdminBookingPopup', ($uibModal, $timeout, $document) ->

  open: (config) ->
    $uibModal.open
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
      templateUrl: 'admin_booking_popup.html'
      resolve:
        config: () -> config

