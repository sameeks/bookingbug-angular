'use strict'

angular.module('BB.Models').factory "AdminSlotModel", ($q, BBModel, BaseModel,
  TimeSlotModel) ->

  class Admin_Slot extends TimeSlotModel

    constructor: (data) ->
      super(data)
      @title = @full_describe
      if @status == 0
        @title = "Available"
      @datetime = moment(@datetime)
      @start = @datetime
      @end = @end_datetime
      @end = @datetime.clone().add(@duration, 'minutes')
      @time = @start.hour()* 60 + @start.minute()
      @startEditable  = false
      @durationEditable  = false
      # set to all day if it's a 24 hours span
      @allDay = false
      @allDay = true if (@duration_span && @duration_span == 86400)
      if @status == 3
        @startEditable  = true
        @durationEditable  = true
        @className = "status_blocked"
      else if @status == 4
        @className = "status_booked"
      else if @status == 0
        @className = "status_available"
      if @multi_status
        for k,v of @multi_status
          @className += " status_" + k
