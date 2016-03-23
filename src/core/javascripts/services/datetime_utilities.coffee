angular.module('BB.Services').factory "DateTimeUlititiesService", (AlertService) ->

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

  checkRequestedTime: (day, time_slots, current_item) ->
    # current_item = $scope.bb.current_item

    if (current_item.requested_time or current_item.time) and current_item.requested_date and day.date.isSame(current_item.requested_date)
      found_time = false

      for slot in time_slots
        if (slot.time is current_item.requested_time)
          current_item.requestedTimeUnavailable()
          $scope.selectSlot(day, slot)
          found_time = true
          $scope.days = []
          return  # hey if we just picked the day and routed - then move on!

        if (current_item.time and current_item.time.time is slot.time and slot.avail is 1)
          if $scope.selected_slot and $scope.selected_slot.time isnt current_item.time.time
            $scope.selected_slot = current_item.time
          current_item.setTime(slot)  # reset it - just in case this is really a new slot!
          found_time = true

      if !found_time
        current_item.requestedTimeUnavailable()
