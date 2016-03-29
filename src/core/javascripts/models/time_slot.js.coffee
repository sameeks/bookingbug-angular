'use strict';

###**
* @ngdoc service
* @name BB.Models:TimeSlot
*
* @description
* Representation of an TimeSlot Object
*
* @property {string} service Service
* @property {date} time_12 Time slot in h:mm format
* @property {date} time_24 Time slot in am/pm format
* @property {date} start Slort start date
* @property {date} end Slot end time
* @property {string} service The service of time slot
* @property {string} get Get the time slot
* @property {string} selected The selected
* @property {boolean} disabled Verify if time slot are disabled or not
* @property {string} disabled_reason The disabled reason
* @property {string} availability The availability of time slot
* @property {string} avail The avail of time slot
###

angular.module('BB.Models').factory "TimeSlotModel", ($q, $window, BBModel, BaseModel, DateTimeUlititiesService) ->

  class TimeSlot extends BaseModel

    constructor: (data, service) ->
      super(data)
      @service = service
      @time_12 = @print_time12()
      @time_24 = @print_time()
      @time_moment = DateTimeUlititiesService.convertTimeSlotToMoment({date: moment()}, @)
    ###**
    * @ngdoc method
    * @name print_time
    * @methodOf BB.Models:TimeSlot
    * @description
    * Shows the time for a  slot.
    *
    * @returns {string} Time
    ###
    # 24 hour time
    print_time: ->
      if @start
        @start.format("h:mm")
      else
        t = @get('time')
        if t%60 < 10
          min = "0" + t%60
        else
          min = t%60
        "" + Math.floor(t / 60) + ":" + min

    ###**
    * @ngdoc method
    * @name print_end_time
    * @methodOf BB.Models:TimeSlot
    * @description
    * Shows the slot end time
    *
    * @returns {string} End time
    ###
    # 24 hour time
    print_end_time: (dur) ->
      if @end
        @end.format("h:mm")
      else
        dur = @service.listed_durations[0] if !dur
        t = @get('time') + dur

        if t%60 < 10
          min = "0" + t%60
        else
          min = t%60
        "" + Math.floor(t / 60) + ":" + min

    ###**
    * @ngdoc method
    * @name print_time12
    * @methodOf BB.Models:TimeSlot
    * @description
    * Shows the time in h:mm format.
    *
    * @returns {string} Time
    ###
    # 12 hour time
    print_time12: (show_suffix = true) ->
      t = @get('time')
      h = Math.floor(t / 60)
      m = t%60
      suffix = 'am'
      suffix = 'pm' if h >=12
      h -=12 if (h > 12)
      time = $window.sprintf("%d.%02d", h, m)
      time += suffix if show_suffix
      return time

    ###**
    * @ngdoc method
    * @name print_end_time12
    * @methodOf BB.Models:TimeSlot
    * @description
    * Shows the end time in h:mm format.
    *
    * @returns {date} End time
    ###
    # 12 hour time
    print_end_time12: (show_suffix = true, dur) ->
      dur = null
      if !dur
        if @service.listed_duration?
          dur = @service.listed_duration
        else
          dur = @service.listed_durations[0]
      t = @get('time') + dur
      h = Math.floor(t / 60)
      m = t%60
      suffix = 'am'
      suffix = 'pm' if h >=12
      h -=12 if (h > 12)
      end_time = $window.sprintf("%d.%02d", h, m)
      end_time += suffix if show_suffix
      return end_time

    ###**
    * @ngdoc method
    * @name availability
    * @methodOf BB.Models:TimeSlot
    * @description
    * Gets the  availability
    *
    * @returns {object} Availability
    ###
    availability: ->
      @avail

    ###**
    * @ngdoc method
    * @name select
    * @methodOf BB.Models:TimeSlot
    * @description
    * Sets a time slot as selected.
    *
    * @returns {boolean} True
    ###
    select: ->
      @selected = true

    ###**
    * @ngdoc method
    * @name unselect
    * @methodOf BB.Models:TimeSlot
    * @description
    * Sets a time slot as unselected.
    *
    * @returns {boolean} If this is unselect
    ###
    unselect: ->
      delete @selected if @selected

    ###**
    * @ngdoc method
    * @name disable
    * @methodOf BB.Models:TimeSlot
    * @description
    * Disables the time slot using the reason parameter.
    *
    * @param {string} reason reason to disable the slot
    *
    * @returns {boolean} If this is a disabled
    ###
    disable: (reason)->
      @disabled = true
      @disabled_reason = reason

    ###**
    * @ngdoc method
    * @name enable
    * @methodOf BB.Models:TimeSlot
    * @description
    * Enables the time slot.
    *
    * @returns {boolean} If this is a enable
    ###
    enable: ->
      delete @disabled if @disabled
      delete @disabled_reason if @disabled_reason

    ###**
    * @ngdoc method
    * @name status
    * @methodOf BB.Models:TimeSlot
    * @description
    * Gets the time slot status
    *
    * @returns {string} Slot status
    ###
    status: ->
      return "selected" if @selected
      return "disabled" if @disabled
      return "enabled" if @availability() > 0
      return "disabled"

    ###**
    * @ngdoc method
    * @name $query
    * @methodOf BB.Models:TimeSlot
    * @description
    * Static function that loads an array of time slots from a company object
    *
    * @returns {promise} A returned promise
    ###
    @$query: (params) ->
      TimeSlotService.query(params)
