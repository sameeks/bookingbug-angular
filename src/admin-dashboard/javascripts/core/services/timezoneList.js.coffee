'use strict'

###*
* @ngdoc service
* @name BBAdminDashboard.TimezoneList
* @description
* Factory for retrieving a list of timezones
###
timezoneListFactory = ($translate, orderByFilter) ->

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

  ###*
  * @ngdoc function
  * @name generateTzList
  * @methodOf BBAdminDashboard.Services:TimezoneList
  * @description Generates list of timezones for display on FE, removing duplicates and ordering by distance from UTC time
  * @param {String} restrictRegion A string to restrict the timezones to a particular region
  * @returns {Array} A list of timezones
  ###
  generateTzList: (restrictRegion) ->

    locationNames = moment.tz.names()
    locationNames = locationNames.filter (tz) -> tz.indexOf('GMT') is -1

    if (restrictRegion)
      locationNames = locationNames.filter (tz) -> tz.indexOf(restrictRegion) isnt -1

    timezones = mapTimezones(locationNames)
    timezones = _.uniq(timezones, (timezone) -> timezone.display)
    timezones = orderByFilter(timezones, ['order[0]', 'order[1]', 'order[2]'], false)

    return timezones

angular
  .module('BBAdminDashboard')
  .factory 'TimezoneList', timezoneListFactory
