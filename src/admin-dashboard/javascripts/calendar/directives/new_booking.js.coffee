angular.module('BBAdminDashboard.calendar.directives').directive 'bbNewBooking', () ->
  restrict: 'AE'
  replace: true
  scope: true
  controller: ($scope, AdminBookingPopup, $uibModal, $timeout, $rootScope, AdminBookingOptions) ->

    $scope.newBooking = () ->
      AdminBookingPopup.open
        item_defaults:
          day_view: AdminBookingOptions.day_view
          merge_people: true
          merge_resources: true
          date: if moment($scope.$parent.currentDate).isValid() then moment($scope.$parent.currentDate).format('YYYY-MM-DD') else moment().format('YYYY-MM-DD')
        company_id: $rootScope.bb.company.id
        template: 'main'
