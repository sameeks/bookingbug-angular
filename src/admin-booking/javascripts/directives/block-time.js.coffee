angular.module('BBAdminBooking').directive 'bbBlockTime', () ->
  scope: true
  restrict: 'A'
  controller: ($scope, $element, $attrs, AdminPersonService,uiCalendarConfig) ->
    $scope.blockTime = ()->
    	# Block call
      AdminPersonService.block($scope.bb.company, $scope.bb.current_item.person, {start_time: $scope.config.fromDatetime, end_time: $scope.config.toDatetime})
      # Close modal window
      $scope.cancel()
      # Refresh events (will update calendar with the new events)
      uiCalendarConfig.calendars.resourceCalendar.fullCalendar('refetchEvents')