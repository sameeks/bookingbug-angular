'use strict'

###*
* @ngdoc service
* @name BBAdminDashboard.TimezoneOptions
* @description
* Factory for retrieving a list of timezones
###
timezoneOptionsFactory = ($translate, orderByFilter) ->

  cleanUpLocations = () ->
    locationNames = moment.tz.names().filter (tz) -> 
      tz.indexOf('GMT') is -1 && tz.indexOf('Etc') is -1 && tz.match(/[^/]*$/)[0] isnt tz.toUpperCase()
    return locationNames

  mapTimezones = (locationNames) ->
    timezones = []
    for location, index in locationNames
      timezones.push mapTimezoneForDisplay(location, index)
    timezones = _.uniq(timezones, (timezone) -> timezone.display)
    # Order here whilst using [ui-select-choices-lazyload] within ui-select
    timezones = orderByFilter(timezones, ['order[0]', 'order[1]', 'order[2]'], false)    
    return timezones
    
  restrictToRegion = (locationNames, restrictRegion) ->

    filterLocations = (filterBy) ->
      _.filter locationNames, (tz) -> tz.indexOf(filterBy) isnt -1

    if angular.isString(restrictRegion)
      locationNames = filterLocations(restrictRegion)
      return locationNames

    if angular.isArray(restrictRegion)
      locations = []
      _.each restrictRegion, (region) ->
        locations.push(filterLocations(region))
      locationNames = _.flatten(locations)
      return locationNames        

  ###*
  * @ngdoc function
  * @name mapTzForDisplay
  * @methodOf BBAdminDashboard.Services:TimezoneOptions
  * @description Prepares a timezone string for display on FE
  * @param {String} Location
  * @param {Integer} Index
  * @returns {Object}
  ###
  mapTimezoneForDisplay = (location, index) ->
    timezone = {}
    city = location.match(/[^/]*$/)[0].replace(/_/g, ' ')
    tz = moment.tz(location)
    # timezone.display = "(UTC #{tz.format('Z')}) #{$translate.instant("LOCATIONS.#{city}")} (#{tz.format('zz')})"
    timezone.display = "(UTC #{tz.format('Z')}) #{$translate.instant(city)} (#{tz.format('zz')})"
    timezone.value = location
    if index?
      timezone.id = index
      timezone.order = [parseInt(tz.format('Z')), tz.format('zz'), city]
    return timezone     
      
  ###*
  * @ngdoc function
  * @name generateTzList
  * @methodOf BBAdminDashboard.Services:TimezoneOptions
  * @description Generates list of timezones for display on FE, removing duplicates and ordering by distance from UTC time
  * @param {String, Array} Restrict the timezones to one region (String) or multiple regions (Array)
  * @returns {Array} A list of timezones
  ###
  generateTimezoneList = (restrictRegion) ->
    locationNames = cleanUpLocations()
    if restrictRegion
      locationNames = restrictToRegion(locationNames, restrictRegion)
    timezones = mapTimezones(locationNames)
    return timezones

  return {
    mapTimezoneForDisplay: mapTimezoneForDisplay
    generateTimezoneList: generateTimezoneList
  }

angular
  .module('BBAdminDashboard')
  .factory 'TimezoneOptions', timezoneOptionsFactory
