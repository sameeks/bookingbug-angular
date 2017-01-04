'use strict'

###*
* @ngdoc service
* @name BBAdminDashboard.TimezoneOptions
* @description
* Factory for retrieving a list of timezones
###
timezoneOptionsFactory = ($translate, orderByFilter) ->

  restrictToRegion = (locationNames, restrictRegion) ->
    if angular.isString(restrictRegion)
      locationNames = _.filter locationNames, (tz) -> tz.indexOf(restrictRegion) isnt -1
    else if angular.isArray(restrictRegion)
      locations = []
      _.map restrictRegion, (region) ->
        locations.push(_.filter locationNames, (tz) -> tz.indexOf(region) isnt -1)
      locationNames = _.flatten(locations)
    else
      throw new Error('restrictRegion must be Array or String')
    return locationNames

  mapTimezones = (locationNames) ->
    timezones = []
    for location, index in locationNames
      city = location.match(/[^/]*$/)[0].replace(/_/g, ' ')
      tz = moment.tz(location)
      timezones.push
        id: index
        order: [parseInt(tz.format('Z')), tz.format('zz'), city]
        display: "(UTC #{tz.format('Z')}) #{$translate.instant(city)} (#{tz.format('zz')})"
        value: location
    return timezones

  getLocalTimezone = () ->
    location = moment.tz.guess()
    city = location.match(/[^/]*$/)[0].replace(/_/g, ' ')
    tz = moment.tz(location)
    localTimezone =
      display: "(UTC #{tz.format('Z')}) #{$translate.instant(city)} (#{tz.format('zz')})"
      value: location

  ###*
  * @ngdoc function
  * @name generateTzList
  * @methodOf BBAdminDashboard.Services:TimezoneList
  * @description Generates list of timezones for display on FE, removing duplicates and ordering by distance from UTC time
  * @param {String, Array} Restrict the timezones to one region (String) or multiple regions (Array)
  * @returns {Array} A list of timezones
  ###
  generateTzList = (restrictRegion) ->
    locationNames = moment.tz.names()
    locationNames = _.filter locationNames, (tz) -> tz.indexOf('GMT') is -1
    if restrictRegion
      locationNames = restrictToRegion(locationNames, restrictRegion)

    timezones = mapTimezones(locationNames)
    timezones = _.uniq(timezones, (timezone) -> timezone.display)
    timezones = orderByFilter(timezones, ['order[0]', 'order[1]', 'order[2]'], false)
    return timezones

  return {
    getLocalTimezone: getLocalTimezone
    generateTzList: generateTzList
  }

angular
  .module('BBAdminDashboard')
  .factory 'TimezoneOptions', timezoneOptionsFactory
