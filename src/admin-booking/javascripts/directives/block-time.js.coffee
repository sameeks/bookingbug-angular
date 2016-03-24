angular.module('BBAdminBooking').directive 'bbBlockTime', () ->
  scope: true
  restrict: 'A'
  controller: ($scope, $element, $attrs, AdminPersonService, uiCalendarConfig) ->

    params = {company: $scope.bb.current_item.company}
    AdminPersonService.query(params).then (people) ->
      $scope.people = _.sortBy people, 'name'
      p.title = p.name for p in $scope.people

    if $scope.bb.current_item.person? and $scope.bb.current_item.person.id?
      $scope.picked_resource = $scope.bb.current_item.person.id

    $scope.$watch 'picked_resource', (newValue, oldValue)->
      angular.forEach $scope.people, (value, key)->
        if value.id == newValue
          $scope.bb.current_item.person = value
          return

    $scope.blockTime = ()->
      # Block call
      AdminPersonService.block($scope.bb.company, $scope.bb.current_item.person, {start_time: $scope.config.from_datetime, end_time: $scope.config.to_datetime}).then (response)->
        # Refresh events (will update calendar with the new events)
        uiCalendarConfig.calendars.resourceCalendar.fullCalendar('refetchEvents')
        # Close modal window
        $scope.cancel()
