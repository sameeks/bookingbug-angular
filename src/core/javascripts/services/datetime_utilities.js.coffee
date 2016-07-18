'use strict'

angular.module('BB.Services').factory "DateTimeUtilitiesService", (SettingsService) ->

  checkPerson = (basket_item, item_defaults) ->
    return (basket_item.defaults.person and basket_item.defaults.person.self is basket_item.person.self) or _.isBoolean(basket_item.person) or item_defaults.merge_people

  checkResource = (basket_item, item_defaults) ->
    return (basket_item.defaults.resource and basket_item.defaults.resource.self is basket_item.resource.self) or _.isBoolean(basket_item.resource) or item_defaults.merge_resources

  # converts date and time belonging to BBModel.Day and BBModel.TimeSlot into
  # a valid moment object
  convertTimeSlotToMoment: (date, time_slot) ->
    return unless date and moment.isMoment(date) and time_slot
    datetime = moment()
    if SettingsService.getDisplayTimeZone() != SettingsService.getTimeZone()
      datetime = datetime.tz(SettingsService.getTimeZone())
    val = parseInt(time_slot.time)
    hours = parseInt(val / 60)
    mins = val % 60
    datetime.hour(hours)
    datetime.minutes(mins)
    datetime.seconds(0)
    datetime.date(date.date())
    datetime.month(date.month())
    datetime.year(date.year())

    return datetime

  convertMomentToTime: (datetime) ->
    return datetime.minutes() + datetime.hours() * 60

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
