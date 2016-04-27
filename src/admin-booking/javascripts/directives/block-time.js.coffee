angular.module('BBAdminBooking').directive 'bbBlockTime', () ->
  scope: true
  restrict: 'A'
  controller: ($scope, $element, $attrs, AdminPersonService, BBModel, BookingCollections, $rootScope) ->
    # All options (resources, people) go to the same select
    $scope.resources = []
    # If company setup with people add people to select
    if $scope.bb.current_item.company.$has('people')
      $scope.bb.current_item.company.getPeoplePromise().then (people)->
        for p in people
          p.title      = p.name
          p.identifier = p.id + '_p'
          p.group      = 'Staff'

        $scope.resources = _.union $scope.resources, people
    # If company is setup with resources add them to select
    if $scope.bb.current_item.company.$has('resources')
      $scope.bb.current_item.company.getResourcesPromise().then (resources)->
        for r in resources
          r.title      = r.name
          r.identifier = r.id + '_r'
          r.group      = 'Resources '

        $scope.resources = _.union $scope.resources, resources

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
        AdminPersonService.block($scope.bb.company, $scope.bb.current_item.person, {start_time: $scope.config.from_datetime, end_time: $scope.config.to_datetime}).then (response)->
          blockSuccess(response)
      else if typeof $scope.bb.current_item.resource == 'object'
        # Block call
        AdminResourceService.block($scope.bb.company, $scope.bb.current_item.person, {start_time: $scope.config.from_datetime, end_time: $scope.config.to_datetime}).then (response)->
          blockSuccess(response)

    isValid = ()->
      $scope.resourceError = false
      if  (typeof $scope.bb.current_item.person != 'object' && typeof $scope.bb.current_item.resource != 'object')
        $scope.resourceError = true

      if  (typeof $scope.bb.current_item.person != 'object' && typeof $scope.bb.current_item.resource != 'object') || !$scope.config.from_datetime? || !$scope.config.to_datetime
        return false

      return true

    blockSuccess = (response)->
      booking = new BBModel.Admin.Booking(response)
      BookingCollections.checkItems(booking)
      # Refresh events (will update calendar with the new events)
      $rootScope.$broadcast('refetchBookings')
      # Close modal window
      $scope.cancel()

    $scope.changeBlockDay = (blockDay)->
      if blockDay
        $scope.config.from_datetime = $scope.config.min_date.format() 
        $scope.config.to_datetime = $scope.config.max_date.format() 
