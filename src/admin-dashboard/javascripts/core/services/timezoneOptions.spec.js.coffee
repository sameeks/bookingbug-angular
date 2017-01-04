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

  describe 'getLocalTimezone method', () ->

    beforeEach2LvlFn = () ->
      moment = jasmine.createSpy()
      injectDependencies()
      return

    beforeEach beforeEach2LvlFn

    it 'should return local timezone object', () ->
      timezone =
        display: '(UTC +00:00) London (GMT)'
        value: 'Europe/London'

      expect timezoneOptionsFactory.getLocalTimezone()
      .toEqual(timezone)

      return

    return

  return
