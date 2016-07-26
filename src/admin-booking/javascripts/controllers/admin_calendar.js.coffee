'use strict'

angular.module('BB.Directives').directive 'bbAdminCalendar', () ->
  restrict: 'AE'
  replace: true
  scope : true
  controller : 'adminCalendarCtrl'

angular.module('BB.Controllers').controller 'adminCalendarCtrl', ($scope, $element, $controller, $attrs, BBModel, $rootScope) ->

  angular.extend(this, $controller('TimeList', {
    $scope: $scope,
    $attrs: $attrs,
    $element: $element
  }))

  $scope.calendar_view = {
    next_available: false,
    day: false,
    multi_day: false
  }

  $rootScope.connection_started.then ->
    $scope.initialise()

  $scope.initialise = () ->
    # set default view
    if $scope.bb.item_defaults.pick_first_time
      $scope.switchView('next_available')
    else if $scope.bb.current_item.defaults.time?
      $scope.switchView('day')
    else
      $scope.switchView($scope.bb.item_defaults.day_view or 'multi_day')

    $scope.person_name   = $scope.bb.current_item.person.name if $scope.bb.current_item.person
    $scope.resource_name = $scope.bb.current_item.resource.name if $scope.bb.current_item.resource


  $scope.switchView = (view) ->

    if view == "day"
      if $scope.slots and $scope.bb.current_item.time
        for slot in $scope.slots
          if slot.time == $scope.bb.current_item.time.time
            $scope.highlightSlot(slot, $scope.bb.current_item.date)
            break

    # reset views
    for key, value of $scope.calendar_view
      $scope.calendar_view[key] = false

    # set new view
    $scope.calendar_view[view] = true


  $scope.overBook = () ->

    new_timeslot = new BBModel.TimeSlot({time: $scope.bb.current_item.defaults.time, avail: 1})
    new_day = new BBModel.Day({date: $scope.bb.current_item.defaults.datetime, spaces: 1})

    $scope.setLastSelectedDate(new_day.date)
    $scope.bb.current_item.setDate(new_day)

    $scope.bb.current_item.setTime(new_timeslot)

    $scope.bb.current_item.setPerson($scope.bb.current_item.defaults.person)
    $scope.bb.current_item.setResource($scope.bb.current_item.defaults.resource)

    if $scope.bb.current_item.reserve_ready
      $scope.addItemToBasket().then () =>
        $scope.decideNextPage()
    else
      $scope.decideNextPage()
