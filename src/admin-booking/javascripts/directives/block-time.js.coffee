angular.module('BBAdminBooking').directive 'bbBlockTime', () ->
  scope: true
  restrict: 'A'
  controller: ($scope, $element, $attrs, AdminPersonService, AdminResourceService, BBModel, BookingCollections, $rootScope, BBAssets) ->
    # All options (resources, people) go to the same select
    $scope.resources = []

    BBAssets($scope.bb.company).then((assets)->
      $scope.resources = assets
    )

    if !moment.isMoment($scope.bb.to_datetime)
      $scope.bb.to_datetime = moment($scope.bb.to_datetime)

    if !moment.isMoment($scope.bb.from_datetime)
      $scope.bb.from_datetime = moment($scope.bb.from_datetime)

    if !moment.isMoment($scope.bb.to_datetime)
      $scope.bb.to_datetime = moment($scope.bb.to_datetime)

    if $scope.bb.min_date && !moment.isMoment($scope.bb.min_date)
      $scope.bb.min_date = moment($scope.bb.min_date)

    if $scope.bb.max_date && !moment.isMoment($scope.bb.max_date)
      $scope.bb.max_date = moment($scope.bb.max_date)

    $scope.hideBlockAllDay = Math.abs($scope.bb.from_datetime.diff($scope.bb.to_datetime, 'days')) > 0

    # If in "Day" view a person or resource will have been passed in
    if $scope.bb.current_item.person? and $scope.bb.current_item.person.id?
      $scope.picked_resource = $scope.bb.current_item.person.id + '_p'

    if $scope.bb.current_item.resource? and $scope.bb.current_item.resource.id?
      $scope.picked_resource = $scope.bb.current_item.resource.id  + '_r'

    # On select change update the right current_item variable depending
    # whether the selected item is a person or a resource
    $scope.changeResource = ()->
      if $scope.picked_resource?
        $scope.resourceError = false
        parts = $scope.picked_resource.split '_'
        angular.forEach $scope.resources, (value, key)->
          if value.identifier == $scope.picked_resource
            if parts[1] == 'p'
              $scope.bb.current_item.person = value
            else if parts[1] == 'r'
              $scope.bb.current_item.resource = value
            return

    $scope.blockTime = ()->
      if !isValid()
        return false

      if typeof $scope.bb.current_item.person == 'object'
        # Block call
        AdminPersonService.block($scope.bb.company, $scope.bb.current_item.person, {start_time: $scope.bb.from_datetime, end_time: $scope.bb.to_datetime, booking: true}).then (response)->
          blockSuccess(response)
      else if typeof $scope.bb.current_item.resource == 'object'
        # Block call
        AdminResourceService.block($scope.bb.company, $scope.bb.current_item.resource, {start_time: $scope.bb.from_datetime, end_time: $scope.bb.to_datetime, booking: true}).then (response)->
          blockSuccess(response)

    isValid = ()->
      $scope.resourceError = false
      if  (typeof $scope.bb.current_item.person != 'object' && typeof $scope.bb.current_item.resource != 'object')
        $scope.resourceError = true

      if  (typeof $scope.bb.current_item.person != 'object' && typeof $scope.bb.current_item.resource != 'object') || !$scope.bb.from_datetime? || !$scope.bb.to_datetime
        return false

      return true

    blockSuccess = (response)->
      $rootScope.$broadcast('refetchBookings')
      # Close modal window
      $scope.cancel()

    $scope.changeBlockDay = (blockDay)->
      if blockDay
        $scope.bb.from_datetime = $scope.bb.min_date.format()
        $scope.bb.to_datetime = $scope.bb.max_date.format()
