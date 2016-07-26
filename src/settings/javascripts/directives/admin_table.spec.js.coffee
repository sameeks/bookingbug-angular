'use strict'

describe 'BBAdminSettings, adminTable directive', () ->
  $rootScope = null
  $scope = null

  setup = () ->
    module 'BBAdminSettings'

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
