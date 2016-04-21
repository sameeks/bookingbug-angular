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

  $rootScope.connection_started.then ->

    delete $scope.bb.current_item.time

    $scope.week_view = !$scope.bb.current_item.defaults.time
    $scope.has_resources_and_people = $scope.bb.company.$has('people') and $scope.bb.company.$has('resources')
    $scope.person_name = $scope.bb.current_item.person.name if $scope.bb.current_item.person
    $scope.resource_name = $scope.bb.current_item.resource.name if $scope.bb.current_item.resource


  $scope.switchView = () ->
    $scope.week_view = !$scope.week_view


  $scope.overBook = () ->

    new_timeslot = new BBModel.TimeSlot({time: $scope.bb.current_item.defaults.time, avail: 1})
    
    if $scope.selected_day
      $scope.setLastSelectedDate($scope.selected_day.date)
      $scope.bb.current_item.setDate($scope.selected_day)

    $scope.bb.current_item.setTime(new_timeslot)

    $scope.decideNextPage()
