angular.module('BB.Services').factory "DateTimeUtilitiesService", () ->

  slot_checked = false
  # converts date and time belonging to BBModel.Day and BBModel.TimeSlot into
  # a valid moment object
  convertTimeSlotToMoment: (day, time_slot) ->
    return if !day and !time_slot

    datetime = moment()
    val = parseInt(time_slot.time)
    hours = parseInt(val / 60)
    mins = val % 60
    datetime.hour(hours)
    datetime.minutes(mins)
    datetime.seconds(0)
    datetime.date(day.date.date())
    datetime.month(day.date.month())
    datetime.year(day.date.year())

    return datetime


  convertMomentToTime: (datetime) ->
    return datetime.minutes() + datetime.hours() * 60


  checkDefaultTime: (date, time_slots, basket_item, item_defaults) ->

    return if @slot_checked
    return if !(basket_item.defaults.time? and
    ((basket_item.defaults.person and basket_item.defaults.person.self is basket_item.person.self) or _.isBoolean(basket_item.person) or !item_defaults.merge_people) and
      ((basket_item.defaults.resource and basket_item.defaults.resource.self is basket_item.resource.self) or _.isBoolean(basket_item.resource) or !item_defaults.merge_resources))

    found_time_slot = null
    @slot_checked: true

    if basket_item.defaults.time and (basket_item.defaults.date and date.isSame(basket_item.defaults.date, 'day') or !basket_item.defaults.date)

      for slot in time_slots

        if (basket_item.defaults.time and basket_item.defaults.time is slot.time) and slot.avail is 1
          found_time_slot = slot
          break

    return found_time_slot
