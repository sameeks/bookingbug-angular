'use strict';

describe 'BBAdminDashboard, timezoneOptionsFactory', () ->

  $translate = null
  orderByFilter = null
  timezoneOptionsFactory = null
  locationNames = null

  beforeEachFn = () ->
    module('BBAdminDashboard')
    return

  beforeEach beforeEachFn

  injectDependencies = () ->
    inject ($injector) ->
      $translate = $injector.get '$translate'
      orderByFilter = $injector.get 'orderByFilter'
      timezoneOptionsFactory = $injector.get 'TimezoneOptions'
      return

    return

  describe 'mapTzForDisplay method', () ->

    beforeEach2LvlFn = () ->
      moment = jasmine.createSpy()
      injectDependencies()
      return

    beforeEach beforeEach2LvlFn

    it 'should return timezone object with display and value properties', () ->
      timezone =
        display: '(UTC +00:00) London (GMT)'
        value: 'Europe/London'

      expect timezoneOptionsFactory.mapTzForDisplay('Europe/London')
      .toEqual(timezone)

      return

    return

  return
