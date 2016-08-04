'use strict'

describe 'BBAdmin.Controllers, CalendarCtrl', () ->
  $compile = null
  $rootScope = null
  $scope = null

  setup = () ->
    module 'BBAdminBooking'
    module 'BBAdmin'

    inject ($injector) ->
      $rootScope = $injector.get '$rootScope'
      $scope = $rootScope.$new()
      return

    return

  beforeEach setup

  it 'dummy test', ->
    expect true
    .toBe true

  return
