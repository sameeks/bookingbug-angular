'use strict';

describe 'BBAdminDashboard.calendar.controllers, CalendarPageCtrl', () ->
  $compile = null
  $controller = null
  $httpBackend = null
  $rootScope = null
  $state = null
  $log = null

  controllerInstance = null
  $scope = null

  pusherChannelMock = {
    bind: () ->
  }

  companyMock = {
    getPusherChannel: (channelName) ->
      pusherChannelMock
  }

  bbMockCompanyHasPeople = {
    company: {
      $has: (type) ->
        if type is 'people'
          return true;

        return false;
    }
  }

  bbMockCompanyHasResources = {
    company: {
      $has: (type) ->
        if type is 'resources'
          return true

        return false
    }
  }

  setup = () ->
    module('BBAdminDashboard')
    module('BB')

    inject ($injector) ->
      $compile = $injector.get '$compile'
      $controller = $injector.get '$controller'
      $httpBackend = $injector.get '$httpBackend'
      $rootScope = $injector.get '$rootScope'
      $scope = $rootScope.$new()
      $state = $injector.get '$state'
      $log = $injector.get '$log'

    $scope.adminlte = {}
    $scope.company = companyMock;

    spyOn pusherChannelMock, 'bind'
    spyOn $state, 'go'
    .and.callThrough()

    return

  beforeEach setup

  getControllerInstance = () ->
    return $controller(
      'CalendarPageCtrl'
      '$log': $log
      '$scope': $scope
      '$state': $state
    )
    return

  it 'bind proper events on company "bookings" pusher channel', () ->
    controllerInstance = getControllerInstance()

    expect pusherChannelMock.bind.calls.argsFor(0)[0]
    .toEqual('create')

    expect pusherChannelMock.bind.calls.argsFor(1)[0]
    .toEqual('update')

    expect pusherChannelMock.bind.calls.argsFor(2)[0]
    .toEqual('destroy')

    return

  describe 'current state is different than calendar', () ->
    beforeEach () ->
      $state.current.name = 'calendar' # TODO find better way to set current state
      return

    afterEach () ->
      expect pusherChannelMock.bind.calls.count()
      .toEqual 3
      return

    it 'redirects to people', () ->
      $scope.bb = bbMockCompanyHasPeople
      controllerInstance = getControllerInstance()

      expect $state.go
      .toHaveBeenCalledWith('calendar.people')
      return

    it 'redirects to resources', () ->
      $scope.bb = bbMockCompanyHasResources
      controllerInstance = getControllerInstance()

      expect $state.go
      .toHaveBeenCalledWith('calendar.resources')
      return

    return

  return