'use strict'

angular.module('BB.Directives').directive 'bbCalendarAdmin', () ->
  restrict: 'AE'
  replace: true
  scope : true
  controller : 'calendarAdminCtrl'


angular.module('BB.Controllers').controller 'calendarAdminCtrl', ($scope, $element, $controller, $attrs, $modal, BBModel, $rootScope) ->

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

    # clear selected time to restore original state
    delete $scope.bb.current_item.time

    # set default view
    if $scope.bb.item_defaults.pick_first_time
      $scope.switchView('next_available')
    else if $scope.bb.current_item.defaults.time
      $scope.switchView('day')
    else
      $scope.switchView('multi_day')

    $scope.person_name   = $scope.bb.current_item.person.name if $scope.bb.current_item.person
    $scope.resource_name = $scope.bb.current_item.resource.name if $scope.bb.current_item.resource


  $scope.switchView = (view) ->
    for key, value of $scope.calendar_view
      $scope.calendar_view[key] = false
    $scope.calendar_view[view] = true


  $scope.overBook = () ->

    new_timeslot = new BBModel.TimeSlot({time: $scope.bb.current_item.defaults.time, avail: 1})
    
    if $scope.selected_day
      $scope.setLastSelectedDate($scope.selected_day.date)
      $scope.bb.current_item.setDate($scope.selected_day)

    $scope.bb.current_item.setTime(new_timeslot)

    $scope.decideNextPage()
