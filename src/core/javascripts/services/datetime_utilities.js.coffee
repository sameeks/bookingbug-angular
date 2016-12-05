'use strict'

###**
* @ngdoc service
* @name BB.Services:DateTimeUtilities
*
* @description
* Service for manipulating datetime objects
*
####

angular.module('BB.Services').factory "DateTimeUtilitiesService", (GeneralOptions, CompanyStoreService) ->


  ###**
  * @ngdoc method
  * @name checkPerson
  * @methodOf BB.Services:DateTimeUtilities
  * @description
  * Checks if basket_item has default person 
  * @param {Object} basket_item The basket item object
  * @param {Object} item_defaults The item defaults object
  *
  * @returns {boolean} 
  ###
  checkPerson = (basket_item, item_defaults) ->
    return (basket_item.defaults.person and basket_item.defaults.person.self is basket_item.person.self) or _.isBoolean(basket_item.person) or item_defaults.merge_people

  ###**
  * @ngdoc method
  * @name checkResource
  * @methodOf BB.Services:DateTimeUtilities
  * @description
  * Checks if basket_item has default resource
  * @param {Object} basket_item The basket item object
  * @param {Object} item_defaults The item defaults object
  *
  * @returns {boolean} 
  ###
  checkResource = (basket_item, item_defaults) ->
    return (basket_item.defaults.resource and basket_item.defaults.resource.self is basket_item.resource.self) or _.isBoolean(basket_item.resource) or item_defaults.merge_resources


  ###**
  * @ngdoc method
  * @name convertTimeToMoment
  * @methodOf BB.Services:DateTimeUtilities
  * @description
  * Converts date and time to valid moment object
  * @param {Moment} date The date object to convert
  * @param {integer} time The time integer to convert
  *
  * @returns {object} Moment object converted from date/time 
  ###
  convertTimeToMoment: (date, time) ->
    return unless date and moment.isMoment(date) and angular.isNumber(time)
    datetime = moment()
    # if user timezone different than company timezone
    if GeneralOptions.display_time_zone != CompanyStoreService.time_zone
      datetime = datetime.tz(CompanyStoreService.time_zone)
    val = parseInt(time)
    hours = parseInt(val / 60)
    mins = val % 60
    datetime.hour(hours)
    datetime.minutes(mins)
    datetime.seconds(0)
    datetime.date(date.date())
    datetime.month(date.month()) 
    datetime.year(date.year())

    return datetime


  ###**
  * @ngdoc method
  * @name convertMomentToTime
  * @methodOf BB.Services:DateTimeUtilities
  * @description
  * Converts moment object to time 
  * @param {Moment} datetime the datetime object to convert
  *
  * @returns {integer} Datetime integer converted from moment object 
  ###
  convertMomentToTime: (datetime) ->
    return datetime.minutes() + datetime.hours() * 60


  ###**
  * @ngdoc method
  * @name checkDefaultTime
  * @methodOf BB.Services:DateTimeUtilities
  * @description
  *  Checks if basket_item default time exists 
  * @param {Moment} date The date object
  * @param {Array} time_slots An array of time slots 
  * @param {Object} basket_item The basket item object
  * @param {Object} item_defaults The item defaults object
  * @returns {Object} object describing matching slot
  ###
  checkDefaultTime: (date, time_slots, basket_item, item_defaults) ->
    if !basket_item.defaults.time
      match = null
    else if checkPerson(basket_item, item_defaults) and checkResource(basket_item, item_defaults)
      match = "full"
    else
      match = "partial"

    found_time_slot = null

    if basket_item.defaults.time and (basket_item.defaults.date and date.isSame(basket_item.defaults.date, 'day') or !basket_item.defaults.date)

      time = if basket_item.time then basket_item.time.time else basket_item.defaults.time

      for slot in time_slots
        if time and time is slot.time and slot.avail is 1
          found_time_slot = slot
          break

    return {
      match: match
      slot: found_time_slot
    }
