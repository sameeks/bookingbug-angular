'use strict'

angular.module('BBAdmin.Controllers').controller 'DashboardContainer', ($scope,
  $rootScope, $location, $uibModal, $document) ->

  $scope.selectedBooking = null
  $scope.poppedBooking = null

  $scope.selectBooking = (booking) ->
    $scope.selectedBooking = booking

  $scope.popupBooking = (booking) ->
    $scope.poppedBooking = booking

    modalInstance = $uibModal.open {
      appendTo: angular.element($document[0].getElementById('bb'))
      templateUrl: 'full_booking_details',
      controller: ModalInstanceCtrl,
      scope: $scope,
      backdrop: true,
      resolve: {
        items: () => {booking: booking}
      }
    }

    modalInstance.result.then (selectedItem) =>
      $scope.selected = selectedItem
    , () =>
      console.log('Modal dismissed at: ' + new Date())

  ModalInstanceCtrl = ($scope, $uibModalInstance, items) ->
    angular.extend($scope, items)
    $scope.ok = () ->
      if items.booking && items.booking.self
        items.booking.$update()
      $uibModalInstance.close();
    $scope.cancel = () ->
      $uibModalInstance.dismiss('cancel');

  # a popup performing an action on a time, possible blocking, or mkaing a new booking
  $scope.popupTimeAction = (prms) ->

    modalInstance = $uibModal.open {
      appendTo: angular.element($document[0].getElementById('bb'))
      templateUrl: $scope.partial_url + 'time_popup',
      controller: ModalInstanceCtrl,
      scope: $scope,
      backdrop: false,
      resolve: {
        items: () => prms
      }
    }
