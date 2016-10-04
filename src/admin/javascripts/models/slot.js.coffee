'use strict'

angular.module('BB.Models').factory "AdminSlotModel", ($q, BBModel, BaseModel, TimeSlotModel, SlotCollections, $window) ->

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
      @title = @full_describe
   #   @startEditable  = false
   #   @durationEditable  = false
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


    useFullTime: () ->
      @using_full_time = true
      @start = @datetime.clone().subtract(@pre_time, 'minutes') if @pre_time
      @end = @datetime.clone().add(@duration + @post_time, 'minutes') if @post_time



    $refetch: () ->
      defer = $q.defer()
      @$flush('self')
      @$get('self').then (res) =>
        @constructor(res)
        if @using_full_time
          @useFullTime()
        BookingCollections.checkItems(@)
        defer.resolve(@)
      , (err) ->
        defer.reject(err)
      defer.promise




    @$query: (params) ->
      if params.slot
        params.slot_id = params.slot.id
      if params.date
        params.start_date = params.date
        params.end_date = params.date
      if params.company
        company = params.company
        delete params.company
        params.company_id = company.id
      params.per_page = 1024 if !params.per_page?
      params.include_cancelled = false if !params.include_cancelled?
      defer = $q.defer()
      existing = SlotCollections.find(params)
      if existing  && !params.skip_cache
        defer.resolve(existing)
      else
        src = company
        src ||= params.src
        delete params.src if params.src
        if params.skip_cache
          SlotCollections.delete(existing) if existing
          src.$flush('slots', params)

        src.$get('slots', params).then (resource) ->
          if resource.$has('slots')
            resource.$get('slots').then (slots) ->
              models = (new BBModel.Admin.Slot(b) for b in slots)
              spaces = new $window.Collection.Slot(resource, models, params)
              SlotCollections.add(spaces)
              defer.resolve(spaces)
            , (err) ->
              defer.reject(err)
          else
            slot = new BBModel.Admin.Slot(resource)
            defer.resolve(slot)

        , (err) ->
          defer.reject(err)
      defer.promise

