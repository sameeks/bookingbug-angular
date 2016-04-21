angular.module('BBAdminBooking').directive 'bbAdminBookingPopup', (AdminBookingPopup) ->
  restrict: 'A'
  link: (scope, element, attrs) ->

    element.bind 'click', () ->
      scope.open()

  controller: ($scope) ->

    $scope.open = () ->
      AdminBookingPopup.open()
