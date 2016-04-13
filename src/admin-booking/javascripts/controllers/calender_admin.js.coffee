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

    $scope.week_view = !$scope.bb.current_item.defaults.time


  $scope.switchView = () ->
    $scope.week_view = !$scope.week_view


  $scope.overBook = ->

    new_timeslot = new BBModel.TimeSlot({time: $scope.current_item.defaults.time, avail: 1})
    
    $scope.selectSlot(new_timeslot)
