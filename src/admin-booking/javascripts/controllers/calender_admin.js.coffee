'use strict'

angular.module('BB.Directives').directive 'calendarAdmin', () ->
  restrict: 'AE'
  replace: true
  scope : true
  controller : 'calendarAdminCtrl'


angular.module('BB.Controllers').controller 'calendarAdminCtrl', ($scope, $element, $controller, $attrs, $modal, BBModel) ->
  $scope.adult_count    = 0
  $scope.show_child_qty = false
  $scope.show_price     = false

  angular.extend(this, $controller('TimeList',
    {$scope: $scope,
    $attrs: $attrs,
    $element: $element}
    )
  )

  $scope.week_view = true
  $scope.name_switch = "switch to week view"

  $scope.switchWeekView = () ->
    if $scope.week_view
      $scope.week_view = false
      $scope.name_switch = "switch to day view"
    else
      $scope.week_view = true
      $scope.name_switch = "switch to week view"

  $scope.bookAnyway = ->
    $scope.new_timeslot = new BBModel.TimeSlot({time: $scope.current_item.defaults.time, avail: 1})
    $scope.selectSlot($scope.new_timeslot)
