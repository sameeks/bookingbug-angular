'use strict';

###
* @ngdoc controller
* @name BBAdminDashboard.calendar.controllers.controller:CalendarPageCtrl
#
* @description
* Controller for the calendar page
###
angular.module('BBAdminDashboard.calendar.controllers')
.controller 'CalendarPageCtrl', ($log, $scope, $state) ->
  'ngInject'

  init = () ->

    bindToPusherChannel()

    if $state.current.name is 'calendar'
      gotToProperState()

    return

  gotToProperState = () ->

    if $scope.bb.company.$has('people')
      $state.go("calendar.people")
    else if $scope.bb.company.$has('resources')
      $state.go("calendar.resources")

    return

  bindToPusherChannel = () ->
    pusherChannel = $scope.company.getPusherChannel('bookings')

    if pusherChannel
      pusherChannel.bind 'create', refetch
      pusherChannel.bind 'update', refetch
      pusherChannel.bind 'destroy', refetch

    return

  refetch = _.throttle (data) ->
    $log.info '== booking push received in bookings == ', data
    $scope.$broadcast 'refetchBookings', data
  , 1000, {leading: false}

  init()

  return
