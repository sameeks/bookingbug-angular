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

  describe 'mapTimezoneForDisplay method', () ->

    beforeEach2LvlFn = () ->
      moment = jasmine.createSpy()
      injectDependencies()
      return

    beforeEach beforeEach2LvlFn

    it 'should return timezone object with display and value properties', () ->
      
      timezone =
        display: '(UTC +00:00) London (GMT)'
        value: 'Europe/London'

      expect timezoneOptionsFactory.mapTimezoneForDisplay('Europe/London')
      .toEqual(timezone)

      return

    it 'should return timezone object with id and order properties', () ->
      
      timezone =
        display: '(UTC +07:00) Krasnoyarsk (+07)'
        value: 'Asia/Krasnoyarsk'
        id: 1
        order: [7, '+07', 'KRASNOYARSK']

      expect timezoneOptionsFactory.mapTimezoneForDisplay('Asia/Krasnoyarsk', 1)
      .toEqual(timezone)

      return

    return

  return
