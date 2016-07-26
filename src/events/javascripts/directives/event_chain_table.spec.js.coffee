'use strict'

describe 'BBAdminEvents, eventChainTable directive', () ->
  $rootScope = null
  $scope = null

  setup = () ->

    module 'BBAdminEvents'

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
