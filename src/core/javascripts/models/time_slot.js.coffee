'use strict';


###**
* @ngdoc service
* @name BB.Models:TimeSlot
*
* @description
* Representation of an TimeSlot Object
*
* @property {string} service The service
* @property {date} time_12 The time_12 of time slot
* @property {date} time_24 The time_24 of time slot
* @property {date} start The start time of the slot
* @property {date} end The end time of the slot
* @property {string} service The service of time slot
* @property {string} get Get the time slot
* @property {string} selected The selected
* @property {boolean} disabled Verify if time slot are disabled or not
* @property {string} disabled_reason The disabled reason
* @property {string} availability The availability of time slot
* @property {string} avail The avail of time slot
###


angular.module('BB.Models').factory "TimeSlotModel", ($q, $window, BBModel, BaseModel) ->

  class TimeSlot extends BaseModel

    constructor: (data, service) ->
      super(data)
      @service = service
      @time_12 = @print_time12()
      @time_24 = @print_time()

    ###**
    * @ngdoc method
    * @name print_time
    * @methodOf BB.Models:TimeSlot
    * @description
    * Print time of the slot
    *
    * @returns {date} The returning time 
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
    * Print end time of the slot
    *
    * @returns {date} The returning end time 
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
    * Print 12 hour time
    *
    * @returns {date} The returning 12 hour time
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
    * Print 12 hour end time
    *
    * @returns {date} The returning 12 hour end time
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
    * Get availability
    *
    * @returns {object} The returning availability
    ###
    availability: ->
      @avail

    ###**
    * @ngdoc method
    * @name select
    * @methodOf BB.Models:TimeSlot
    * @description
    * Checks if selected is true
    *
    * @returns {boolean} If this is checked
    ###
    select: ->
      @selected = true

    ###**
    * @ngdoc method
    * @name unselect
    * @methodOf BB.Models:TimeSlot
    * @description
    * Unselect if is selected
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
    * Disable time slot by reason
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
    * Enable time slot
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
    * Get status of the time slot
    *
    * @returns {object} The returned status
    ###
    status: ->
      return "selected" if @selected
      return "disabled" if @disabled
      return "enabled" if @availability() > 0
      return "disabled"
