
angular.module('BBAdminBooking').directive 'bbAdminBookingPopup', (WidgetModalService) ->
  restrict: 'A'
  link: (scope, element, attrs) ->

    element.bind 'click', () ->
      scope.open()

  controller: ($scope) ->

    $scope.open = () ->
      WidgetModalService.open()

