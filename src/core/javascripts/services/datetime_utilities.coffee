angular.module('BB.Services').factory "DateTimeUtilitiesService", () ->

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


  checkDefaultTime: (date, time_slots, basket_item) ->

    return if !basket_item.defaults.time

    found_time_slot = null

    if (basket_item.defaults.time or basket_item.time) and basket_item.date and date.isSame(basket_item.date.date, 'day')

      for slot in time_slots

        if (basket_item.defaults.time and basket_item.defaults.time is slot.time) and slot.avail is 1
          found_time_slot = slot
          break

        # TODO redundant?
        if (basket_item.time and basket_item.time.time is slot.time) and slot.avail is 1
          found_time_slot = slot
          break

      delete basket_item.defaults.time

    return found_time_slot

        